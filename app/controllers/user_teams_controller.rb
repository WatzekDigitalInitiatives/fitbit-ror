class UserTeamsController < ApplicationController
    before_action :authenticate_user!

    def new
      @user = current_user
    end

    def create
      @user_team = UserTeam.new
      @user_team.user_id = current_user.id
      @team = Team.where(invitecode: params[:invitecode]).first
      unless @team
        flash[:notice] = 'Sorry, no team found with that invite code.'
        redirect_to join_team_path
        return
      end
      if UserTeam.find_by(user_id: current_user.id, event_id: @event.id)
        flash[:notice] = 'You are already a member of this team.'
        redirect_to join_team_path
        return
      end
      @user_team.team_id = @team.id
      respond_to do |format|
          if @user_team.save
              format.html { redirect_to dashboard_path, notice: 'You successfully joined the team!' }
              format.json { render :show, status: :created, location: @user_event }
          else
              format.html { redirect_to join_event_path, notice: 'Sorry, you were not able to join the team. Please check your code.' }
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
