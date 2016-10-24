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
      if UserTeam.find_by(user_id: current_user.id, team_id: @team.id)
        flash[:notice] = 'You are already a member of this team.'
        redirect_to :back
        return
      end
      @user_team.team_id = @team.id
      respond_to do |format|
          if @user_team.save
              format.html { redirect_to my_teams_path, notice: 'You successfully joined the team!' }
              format.json { render :show, status: :created, location: @user_event }
          else
              format.html { redirect_to :back, notice: 'Sorry, you were not able to join the team. Please check your code.' }
              format.json { render json: @user_event.errors, status: :unprocessable_entity }
          end
      end
    end

    def make_admin
      @user_team = UserTeam.where(user_id: params[:user_id], team_id: params[:team_id]).first
      @user_team.admin = true
      respond_to do |format|
        if @user_team.save
            format.html { redirect_to :back, notice: 'User successfully made team admin.' }
            format.json { render :show, status: :ok, location: @user_team }
        else
            format.html { redirect_to :back, notice: 'Sorry, we were not able to make user team admin.' }
            format.json { render json: @user_team.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_event_params
        params.permit(:invitecode)
    end
end
