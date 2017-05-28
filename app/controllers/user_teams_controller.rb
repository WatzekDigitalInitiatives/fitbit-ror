class UserTeamsController < ApplicationController
    before_action :authenticate_user!

    def new
        @user = current_user
        # flash[:notice] = 'This team is private.'
    end

    def create
        @user_team = UserTeam.new
        @user_team.user_id = current_user.id
        @team = Team.where(invitecode: params[:invitecode]).first
        unless @team
            flash[:notice] = 'Sorry, no team found with that invite code.'
            return redirect_to join_team_path
        end
        if UserTeam.find_by(user_id: current_user.id, team_id: @team.id)
            flash[:notice] = 'You are already a member of this team.'
            return redirect_to :back
        end
        @user_team.team_id = @team.id
        respond_to do |format|
            if @user_team.save
                format.html { redirect_to @team, notice: 'You successfully joined the team!' }
                format.json { render :show, status: :created, location: @user_event }
            else
                format.html { redirect_to :back, notice: 'Sorry, you were not able to join the team. Please check your code.' }
                format.json { render json: @user_event.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        UserTeam.find_by(user_id: params[:user_id], team_id: params[:team_id]).destroy
        respond_to do |format|
            format.html { redirect_to teams_url, notice: 'You successfully left the team' }
            format.json { head :no_content }
        end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_event_params
        params.permit(:invitecode)
    end
end
