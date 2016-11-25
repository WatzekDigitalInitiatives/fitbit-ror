class ActivitiesController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:pushnotification]

  def verifysub
    if params[:verify] == "5517775dc1f07abc29d53661f0089bb9a14070de696cf21a490c3038b4297295"
      head :no_content
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def pushnotification
      push_data = ActiveSupport::JSON.decode(request.body.read)
      user_id = push_data[0]["subscriptionId"]
      # render :text => @user_id.inspect
      update_activity(user_id)
      head :no_content
  end

  private

  def update_activity(user_id)
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


    @activity = Activity.find_by(entry_date: today, user_id: @user.id).first

    if !@activity.empty?
      # update that activity
      @activity.steps = @steps
      @activity.save
    else
      # create an activity for that user
      @user.activities.create(entry_date: today, steps: @steps, goal: @goal, goal_met: @goal_met)
    end

  end

end
