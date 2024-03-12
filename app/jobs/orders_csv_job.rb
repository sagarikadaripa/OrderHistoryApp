class OrdersCsvJob < ApplicationJob
  queue_as :default

  def perform(user,headers)
    begin
      orders = user.orders
      order_history = user.process_orders(orders)

      generate_and_save_excel(order_history, user,headers)
    rescue Exception => e
      puts "Trace of Error - #{e.message}"
      puts "Trace of Error - #{e.backtrace.join("\n")}"
    end
  end


  private

  def generate_and_save_excel(order_history, user, headers)
    Axlsx::Package.new do |p|
      p.workbook.styles do |style|  # Define styles
        description_style = style.add_style(b: true, fg_color: '212529', sz: 12, alignment: {vertical: :center})
        header_style = style.add_style(
          b: true, sz: 12, bg_color: '0E2C51', fg_color: 'FFFFFF',
          alignment: {vertical: :center, horizontal: :center},
          border: {style: :thin, color: 'DDDDDD'}
        )

        p.workbook.add_worksheet(name: 'User Order History') do |sheet|
          merge_row_count = 0

          # Apply styles to user details
          sheet.add_row ['User Name:', "#{user.username.titleize}"], height: HEIGHT, style: description_style
          merge_row_count += 1

          sheet.add_row ['Email:', user.email], height: HEIGHT, style: description_style
          merge_row_count += 1

          sheet.add_row ['Phone:', user.phone], height: HEIGHT, style: description_style
          merge_row_count += 1

          sheet.add_row [BLANK], height: HEIGHT
          merge_row_count += 1

          ######################## ORDER DETAILS #######################
          sheet.add_row ['Product Code', 'Product Name', 'Category', 'Purchase Date'], height: 25, style: header_style
          merge_row_count += 1

          if order_history.empty?
            sheet.add_row ['No data to show'], height: 25
          else
            order_history.each do |data|
              next if data[:product_name] == 'Unknown'
              sheet.add_row [data[:product_code], data[:product_name], data[:product_category], data[:order_date]]
            end

            sheet.add_row [BLANK], height: HEIGHT
            merge_row_count += 1
            sheet.add_row [BLANK], height: HEIGHT
            merge_row_count += 1
          end
        end
      end

      # Set the content type and disposition headers for the response
      headers['Content-Type'] = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      headers['Content-Disposition'] = "attachment; filename=#{user.username}_orders.xlsx"

      # Save the Excel file directly to the response body
      headers['rack.hijack'] = true
      headers['rack.hijack_io'] = response.stream
      response.stream.write p.to_stream.read
    end
  end
end
