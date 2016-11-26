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
    goal = daily_goal(client)
    today = Date.today.in_time_zone(user_tmz).to_date.strftime("%Y-%m-%d")

    @activities = @user.activities

    # if user has no entries make today's entry
    if @activities.empty?
      steps = find_steps(client, today)
      goal_met = goal_ach(goal, steps)
      @user.activities.create(entry_date: today, steps: steps, goal: goal, goal_met: goal_met)
    else

    # check for last 5 days in reverse order
      start_date = 5.days.ago.to_date
      end_date = 1.day.ago.to_date

      (start_date..end_date).reverse_each do |date|

        date = date.strftime("%Y-%m-%d")

        @activity = Activity.find_by(entry_date: date, user_id: @user.id)

        if @activity
          # if entry is found break through the loop
          break
        else
          # create an entry fot that date
          steps = find_steps(client, date)
          goal_met = goal_ach(goal, steps)
          @user.activities.create(entry_date: date, steps: steps, goal: goal, goal_met: goal_met)
        end

      end #end of for loop

      # now check if today's entry exists, if not create, else update it
      @activity = Activity.find_by(entry_date: today, user_id: @user.id)
      if @activity
        # if entry is found break through the loop
        break
      else
        # create an entry fot that date
        steps = find_steps(client, date)
        goal_met = goal_ach(goal, steps)
        @user.activities.create(entry_date: today, steps: steps, goal: goal, goal_met: goal_met)
      end

    end #end of if @activities.empty?


  end

  def find_steps(client, date)
    output_steps = client.activity_time_series(resource: 'steps', start_date: date, period: '1d')
    hash = JSON.parse(output_steps.to_json)
    steps = hash["activities-steps"][0]["value"].to_f
    return steps
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
