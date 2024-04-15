# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  def create
    puts "Province ID from form: #{params[:user][:province_id]}"
    super do |resource|
      resource.province_id = params[:user][:province_id]
      resource.save
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :address, :city, :province_id)
  end
end
