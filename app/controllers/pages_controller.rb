class PagesController < ApplicationController
    before_action :authenticate_user!, except: [:home, :about]

    def home
        redirect_to dashboard_path if user_signed_in?
    end

    def dashboard
        @user = current_user
        @participating_events = current_user.events
        @user_id = current_user.id
        @user_events = Event.where(createdby: @user_id)
    end

    def about
    end
end
