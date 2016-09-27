class UserEventsController < ApplicationController
    before_action :authenticate_user!

    def new
      @user_event = UserEvent.new
    end

    def create

    @user_event = UserEvent.new
    @user_event.user_id = current_user.id
    @event = Event.where(invitecode: params[:invitecode]).first
    if !@event
      flash[:notice] = 'Sorry, you were not able to join the event. Please check your code.'
      redirect_to dashboard_path
      return
    end
    @user_event.event_id = @event.id

    respond_to do |format|
      if @user_event.save
        format.html { redirect_to dashboard_path, notice: 'User successfully added to the event.' }
        format.json { render :show, status: :created, location: @user_event }
      else
        format.html { redirect_to dashboard_path, notice: 'Sorry, you were not able to join the event. Please check your code.' }
        format.json { render json: @user_event.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_event_params
      params.permit(:invitecode)
    end
end
