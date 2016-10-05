class PagesController < ApplicationController
    before_action :authenticate_user!, except: [:home, :about]

    def home
        redirect_to dashboard_path if user_signed_in?
    end

    def dashboard
        @user = current_user
        @participating_events = current_user.events
        @participating_events.each do |event|
            event.static_map_preview = [
                'https://maps.googleapis.com/maps/api/staticmap?&size=955x120&maptype=terrain',
                '&markers=color:green%7Clabel:A%7C', event.start_location,
                '&markers=color:red%7Clabel:B%7C', event.end_location,
                '&path=', event.start_location, '|', event.end_location,
                '&scale=2', '&key=', ENV['GOOGLE_API_KEY']
            ].join
        end
    end

    def about
    end
end
