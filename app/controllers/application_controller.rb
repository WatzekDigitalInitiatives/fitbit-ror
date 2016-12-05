class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :create_user_subscription, :set_subscription_date

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

   def create_user_subscription(user)
     client = user.fitbit_client
     client.create_subscription(type: 'activities', subscription_id: user.id)
   end

   def set_subscription_date(user_id, start_date, end_date)
     @user = User.find(user_id)
     @sub = @user.subscription
     if @sub

       if start_date < @sub.earliest_date
         @sub.earliest_date = start_date
         @sub.save
       end

       if end_date > @sub.furthest_date
         @sub.furthest_date = end_date
         @sub.save
       end

     else
       @sub = Subscription.new(earliest_date: start_date, furthest_date: end_date, user_id: user_id)
       @sub.save
     end
   end

end
