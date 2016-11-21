class PagesController < ApplicationController
    before_action :authenticate_user!, except: [:home, :about]

    def home
        redirect_to dashboard_path if user_signed_in?
    end

    def dashboard
        @user = current_user
        client = @user.fitbit_client
        user_tmz = current_user.identity_for("fitbit").timezone
        today = Date.today.in_time_zone(user_tmz).to_date.strftime("%Y-%m-%d")
        output_steps = client.activity_time_series(resource: 'steps', start_date: today, period: '1d')
        hash = JSON.parse(output_steps.to_json)
        @steps = hash["activities-steps"][0]["value"]

        output_goals = client.goals('daily')
        hash = JSON.parse(output_goals.to_json)
        @goal = hash["goals"]["steps"]
        # render json: output_goals

        # show user subscriptions:
        # client = @user.fitbit_client
        # output = client.subscriptions(type: 'activities')
        # render json: output
    end

    def about
    end
end
