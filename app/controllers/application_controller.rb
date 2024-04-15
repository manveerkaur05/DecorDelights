class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
  
    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:province_id, :other_user_params])
      devise_parameter_sanitizer.permit(:account_update, keys: [:province_id, :other_user_params])
    end
  end
  