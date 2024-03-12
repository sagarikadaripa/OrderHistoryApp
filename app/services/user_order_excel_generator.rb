class UserOrderExcelGenerator
  def initialize(user, orders)
    @user = user
    @orders = orders
  end

  def generate_excel
    Axlsx::Package.new do |p|
      wb = p.workbook
      wb.add_worksheet(name: 'User Order History') do |sheet|
        sheet.add_row ['User Name:', "#{@user.username}"], height: HEIGHT, style: description_style
        sheet.add_row ['Email:', "#{@user.email}"], height: HEIGHT, style: description_style
        sheet.add_row ['Phone:', "#{@user.phone}"], height: HEIGHT, style: description_style
        sheet.add_row [BLANK], height: HEIGHT
        sheet.add_row ['Product Code', 'Product Name', 'Category', 'Purchase Date'], height: 25, style: header_style
        if @orders.empty?
          sheet.add_row ['No data to show'], height: 25
        else
          @orders.each do |order|
            sheet.add_row [order[:product_code], order[:product_name], order[:product_category], order[:order_date]]
          end
        end
      end
      p.serialize(file_path)
    end
  end

  private

  def file_path
    "tmp/#{SecureRandom.uuid}_order.xlsx"
  end

  def description_style
    @description_style ||= Axlsx::Style.new(b: true, fg_color: '212529', sz: 12, alignment: {vertical: :center})
  end

  def header_style
    @header_style ||= Axlsx::Style.new(
      b: true, sz: 12, bg_color: '0E2C51', fg_color: 'FFFFFF',
      alignment: {vertical: :center, horizontal: :center},
      border: {style: :thin, color: 'DDDDDD'}
    )
  end
end
