class PagesController < ApplicationController
    before_action :authenticate_user!, except: [:home, :about]

    def home
        redirect_to dashboard_path if user_signed_in?
    end

    def dashboard
        @user = current_user
    end

    def about
    end
end
