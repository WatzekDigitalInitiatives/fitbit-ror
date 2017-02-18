class ActivitiesController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:pushnotification]

  def verifysub
    if params[:verify] == ENV["PUSH_VERIFICATION_CODE"]
      head :no_content
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def pushnotification
      push_data = ActiveSupport::JSON.decode(request.body.read)
      users = push_data
      head :no_content
      update_activity(users)
  end

  private

  def update_activity(users)
    users.each do |user|

      user_id = user["subscriptionId"]
      @user = User.where(id: user_id).first

      if @user

        refresh_user_token(user_id)

        client = @user.fitbit_client
        goal = daily_goal(client)
        user_tmz = @user.identity_for("fitbit").timezone
        today = Date.today.in_time_zone(user_tmz).to_date.strftime("%Y-%m-%d")
        start_date = @user.subscription.earliest_date
        all_steps = find_steps(client, start_date, today)

        all_steps.each do |past_day|
            date = past_day["dateTime"]
            steps = past_day["value"].to_f
            goal_met = goal_ach(goal, steps)
            @activity = Activity.find_by(entry_date: date, user_id: @user.id)

            if @activity
              if steps != @activity.steps
                @activity.steps = steps
                @activity.goal_met = goal_met
                @activity.save
              end
            else
              # create an entry fot that date
              @user.activities.create(entry_date: date, steps: steps, goal: goal, goal_met: goal_met)
            end
        end
      end

    end

  end

  def find_steps(client, start_date, end_date)
    output_steps = client.activity_time_series(resource: 'steps', start_date: start_date, end_date: end_date)
    hash = JSON.parse(output_steps.to_json)
    past_steps = hash["activities-steps"]
    return past_steps
  end

  def goal_ach(goal, steps)
    if goal < steps
      goal_met = true
    else
      goal_met = false
    end
    return goal_met
  end

  def daily_goal(client)
    output_goals = client.goals('daily')
    hash = JSON.parse(output_goals.to_json)
    goal = hash["goals"]["steps"].to_f
    return goal
  end

end
