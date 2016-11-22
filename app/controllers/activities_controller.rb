class ActivitiesController < ApplicationController

  def push
    if params[:verify].present?
      if params[:verify] == "d324eff6e6c6024d73ff2b4ba4141b000cfe27714365e15a0747f788de84284d"
        head :no_content
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    else
      push_data = ActiveSupport::JSON.decode(request.body.read)
      update_activity(push_data)
      head :no_content
    end
  end

  def update_activity(push_data)
    user_id = push_data["subscriptionId"]
    @user = User.where(id: user_id).first

    client = @user.fitbit_client
    user_tmz = @user.identity_for("fitbit").timezone
    today = Date.today.in_time_zone(user_tmz).to_date.strftime("%Y-%m-%d")

    output_steps = client.activity_time_series(resource: 'steps', start_date: today, period: '1d')
    hash = JSON.parse(output_steps.to_json)
    @steps = hash["activities-steps"][0]["value"].to_f

    output_goals = client.goals('daily')
    hash = JSON.parse(output_goals.to_json)
    @goal = hash["goals"]["steps"].to_f

    if @goal < @steps
      @goal_met = true
    else
      @goal_met = false
    end

    if Activity.find_by(entry_date: today, user_id: @user.id).first
      # update that activity
      @activity = Activity.find_by(entry_date: today, user_id: @user.id).first
      @activity.steps = @steps
      @activity.save
    else
      # create an activity for that user
      @user.activities.create(entry_date: today, steps: @steps, goal: @goal, goal_met: @goal_met)
    end

  end

end
