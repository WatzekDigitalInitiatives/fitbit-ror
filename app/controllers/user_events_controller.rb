class UserEventsController < ApplicationController
    before_action :authenticate_user!

    def new
        @user = current_user
        @user_event = UserEvent.new
    end

    def create
        @user_event = UserEvent.new
        @user_event.user_id = current_user.id
        @event = Event.where(invitecode: params[:invitecode]).first
        unless @event
            flash[:notice] = 'Sorry, no event found with that invite code.'
            redirect_to join_event_path
            return
        end
        if UserEvent.find_by(user_id: current_user.id, event_id: @event.id)
            flash[:notice] = 'You are already registered for this event.'
            redirect_to dashboard_path
            return
        end
        @user_event.event_id = @event.id

        respond_to do |format|
            if @user_event.save
                set_subscription_date(current_user.id, @event.start_date, @event.finish_date)
                create_user_subscription(current_user)
                format.html { redirect_to dashboard_path, notice: 'You successfully joined the event!' }
                format.json { render :show, status: :created, location: @user_event }
            else
                format.html { redirect_to join_event_path, notice: 'Sorry, you were not able to join the event. Please check your code.' }
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
