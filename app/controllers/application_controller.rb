class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

   def configure_permitted_parameters
     added_attrs = [:name, :email, :avatar, :password, :password_confirmation, :remember_me]
     devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
     devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
   end

   def authenticate_user!
     if user_signed_in?
       super
     else
       redirect_to root_path, :notice => 'Please login to continue that action.'
     end
   end
end
