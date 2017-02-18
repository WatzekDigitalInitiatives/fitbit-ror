class PagesController < ApplicationController
    before_action :authenticate_user!, except: [:home, :about]

    def home
        redirect_to dashboard_path if user_signed_in?
    end

    def dashboard
        @user = current_user
        
        client = @user.fitbit_client
        output_goals = client.goals('daily')
        hash = JSON.parse(output_goals.to_json)
        @goal = hash['goals']['steps']

        user_tmz = current_user.identity_for('fitbit').timezone
        today = Date.today.in_time_zone(user_tmz).to_date.strftime('%Y-%m-%d')
        output_steps = client.activity_time_series(resource: 'steps', start_date: today, period: '1d')
        hash = JSON.parse(output_steps.to_json)
        @steps = hash['activities-steps'][0]['value']

        info = client.user_info
        @info = info

        @badges = {}

        info['user']['topBadges'].each do |badge|
            @badges[badge['category']] = badge
        end

    end

    def find_steps(client, start_date, end_date)
        output_steps = client.activity_time_series(resource: 'steps', start_date: start_date, end_date: end_date)
        hash = JSON.parse(output_steps.to_json)
        past_steps = hash['activities-steps']
        past_steps
    end

    def goal_ach(goal, steps)
        goal_met = if goal < steps
                       true
                   else
                       false
                   end
        goal_met
    end

    # END OF CODE TO REMOVE

    def about
    end
end
