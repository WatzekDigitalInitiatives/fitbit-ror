class TeamsController < ApplicationController
    before_action :set_team, only: [:show, :edit, :update, :destroy]
    before_action :check_team_admin, only: [:edit, :destroy]
    before_action :authenticate_user!, only: [:new, :show, :myteams]

    # GET /teams
    # GET /teams.json
    def index
        @user = current_user
        @teams = Team.all
        @teams.each do |team|
          if current_user.present?
            if team.createdby == current_user.id
                team.is_current_user_admin = true
            else
                team.is_current_user_admin = false
            end
          else
            team.is_current_user_admin = false
          end
        end
    end

    def myteams
        @my_teams = current_user.teams
        @user = current_user
        @my_teams.each do |team|
            if team.createdby == current_user.id
                team.is_current_user_admin = true
            else
                team.is_current_user_admin = false
            end
        end
    end

    # GET /teams/1
    # GET /teams/1.json
    def show
        @users = @team.users
        if @team.createdby == current_user.id
            @current_user_admin = true
          else
            @current_user_admin = false
        end
    end

    # GET /teams/new
    def new
        @user = current_user
        @team = Team.new
    end

    # GET /teams/1/edit
    def edit
        @user = current_user
    end

    # POST /teams
    # POST /teams.json
    def create
        @user = current_user
        @team = Team.new(team_params)
        @team.createdby = current_user.id
        @team.invitecode = [*('A'..'Z'), *('0'..'9')].sample(6).join
        @team.hexcolor = '#' + '%06x' % (rand * 0xffffff)

        respond_to do |format|
            if @team.save
                @user_team = UserTeam.new
                @user_team.user_id = current_user.id
                @user_team.team_id = @team.id
                @user_team.admin = true
                if @user_team.save
                    format.html { redirect_to @team, notice: 'Team was successfully created.' }
                    format.json { render :show, status: :created, location: @team }
                end
            else
                format.html { render :new }
                format.json { render json: @team.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /teams/1
    # PATCH/PUT /teams/1.json
    def update
        respond_to do |format|
            if @team.update(team_params)
                format.html { redirect_to @team, notice: 'Team was successfully updated.' }
                format.json { render :show, status: :ok, location: @team }
            else
                format.html { render :edit }
                format.json { render json: @team.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /teams/1
    # DELETE /teams/1.json
    def destroy
        @team.destroy
        respond_to do |format|
            format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_team
        @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
        params.require(:team).permit(:name, :description, :private, :avatar)
    end

    # Checks if user is the admin of the team to edit and destroy event
    def check_team_admin
        if !current_user.present?
            redirect_to @team, notice: 'Only team admin can edit or destroy teams.'
        else
            # check if they are admin
            unless @team.createdby == current_user.id
                redirect_to @team, notice: 'Only team admins can edit or destroy teams.'
            end
        end
    end
end
