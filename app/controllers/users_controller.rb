class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(10)
  end

  def download_orders
    @user = User.find(params[:id])
    headers = {
      'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'Content-Disposition' => "attachment; filename=#{@user.username}_orders.xlsx"
    }
    OrdersCsvJob.perform_later(@user,headers)

    flash[:notice] = "Your order history is being processed. You will receive a notification once it's ready."
    redirect_to users_path
  end
end
