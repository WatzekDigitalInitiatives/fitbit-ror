class TeamEventsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_event, only: [:new]

    def new
        unless @event.team_event
            flash[:notice] = 'Sorry, please select a team event.'
            return redirect_to events_path
        end

        @user = current_user
        @all_teams = Team.where(createdby: @user.id).all

        if @all_teams.empty?
            flash[:notice] = "Sorry, you don't have any teams to enroll."
            return redirect_to @event
        end

        @teams = []
        @all_teams.each do |team|
            @teams << team unless @event.teams.include?(team)
        end

        return redirect_to @event if @teams.empty?

        @team_event = TeamEvent.new
    end

    def create
        @team_event = TeamEvent.new
        @event = Event.where(invitecode: params[:invitecode]).first

        unless @event
            flash[:notice] = 'Sorry, no event found with that invite code.'
            return redirect_to join_event_path
        end
        if TeamEvent.find_by(team_id: params[:team_id], event_id: @event.id)
            flash[:notice] = 'You are already registered for this event.'
            return redirect_to @event
        end
        @team_event.team_id = params[:team_id]
        @team_event.event_id = @event.id

        respond_to do |format|
            if @team_event.save
                @team = Team.where(id: params[:team_id]).first
                @team.users.each do |user|
                    set_subscription_date(user.id, @event.start_date, @event.finish_date)
                    create_user_subscription(user) if user.events.count == 1
                end
                format.html { redirect_to @event, notice: 'Successfully enrolled your team in the event.' }
                format.json { render :show, status: :created, location: @user_event }
            else
                format.html { redirect_to join_event_path, notice: 'Sorry, your team was not able to join the event.' }
                format.json { render json: @user_event.errors, status: :unprocessable_entity }
            end
        end
    end

    private

    def team_event_params
        params.permit(:invitecode, :team_id)
    end

    def set_event
        @event = Event.find(params[:id])
    end
end
