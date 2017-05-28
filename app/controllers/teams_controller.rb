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
                team.is_current_user_admin = if team.createdby == current_user.id
                                                 true
                                             else
                                                 false
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
            team.is_current_user_admin = if team.createdby == current_user.id
                                             true
                                         else
                                             false
                                         end
        end
    end

    # GET /teams/1
    # GET /teams/1.json
    def show
        @user = current_user
        redirect_to join_team_path if !@user.teams.include?(@team) && @team.private
        @users = @team.users
        @range = 4
        @standings = get_team_standings(@range)
        @stats = get_team_stats(@range)
        @current_user_admin = if @team.createdby == current_user.id
                                  true
                              else
                                  false
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
            format.html { redirect_to teams_url, notice: 'Team was successfully disbanded.' }
            format.json { head :no_content }
        end
    end

    def get_team_stats(range)
        finish_date = Date.today + range
        @stats = {}
        @stats['total_steps'] = 0
        @team.users.each do |user|
            (Date.today..finish_date).each do |date|
                @activity = Activity.find_by(entry_date: date, user_id: user.id)
                if @activity
                    @stats['total_steps'] += @activity.steps
                else
                    @stats['total_steps'] += 0
                end
            end
        end
        @stats['avg_steps'] = @stats['total_steps'] / @users.count
        @stats
    end

    def get_team_standings(range)
        finish_date = Date.today + range
        @standings = []
        @team.users.each do |user|
            @data = { 'total_steps' => 0, 'steps' => 0, 'hexcolor' => user.hexcolor, 'name' => user.name, 'avatar' => user.avatar.url, 'id' => user.id, 'goals' => [] }
            (Date.today..finish_date).each do |date|
                @activity = Activity.find_by(entry_date: date, user_id: user.id)
                if @activity
                    @data['total_steps'] += @activity.steps
                    @data['steps'] = @activity.steps
                    @data['goals'].append(@activity.goal_met)
                else
                    @data['total_steps'] += 0
                    @data['steps'] = 0
                    @data['goals'].append(false)
                end
            end
            @standings << @data
        end
        @standings
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
            return redirect_to @team, notice: 'Only the team owner can update or disband teams.'
        else
            # check if they are admin
            unless @team.createdby == current_user.id
                return redirect_to @team, notice: 'Only the team owner can update or disband teams.'
            end
        end
    end
end
