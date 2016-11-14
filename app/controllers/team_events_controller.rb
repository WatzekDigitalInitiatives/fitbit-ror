class TeamEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:new]

  def new

    if !@event.team_event
      flash[:notice] = 'Sorry, please select a team event to join'
      redirect_to events_path
    end

    @user = current_user
    @teams = Team.where(createdby: @user.id).all

    if @teams.empty?
      flash[:notice] = "Sorry, you don't have any teams to join team event."
      redirect_to new_team_path
    end

    @team_event = TeamEvent.new

  end

  def create
    @team_event = TeamEvent.new
    @event = Event.where(invitecode: params[:invitecode]).first

    unless @event
        flash[:notice] = 'Sorry, no event found with that invite code.'
        redirect_to join_event_path
        return
    end
    if TeamEvent.find_by(team_id: params[:team_id], event_id: @event.id)
        flash[:notice] = 'You are already registered for this event.'
        redirect_to dashboard_path
        return
    end
    @team_event.team_id = params[:team_id]
    @team_event.event_id = @event.id

    respond_to do |format|
        if @team_event.save
            format.html { redirect_to dashboard_path, notice: 'Your team successfully joined the event!' }
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
