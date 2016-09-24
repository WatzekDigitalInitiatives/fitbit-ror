class UserEventsController < ApplicationController

    def create
    @user_event = UserEvent.new(user_event_params)

    respond_to do |format|
      if @user_event.save
        format.html { redirect_to :back, notice: 'User successfully added to the event.' }
        format.json { render :show, status: :created, location: @user_event }
      else
        format.html { render :back }
        format.json { render json: @user_event.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_event_params
      params.permit(:user_id, :event_id)
    end
end
