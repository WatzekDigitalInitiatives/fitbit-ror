class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :check_team_admin, only: [:edit, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.where(private: false).all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
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
      params.require(:team).permit(:name, :private, :avatar)
    end

    # Checks if user is the admin of the team to edit and destroy event
    def check_team_admin
        if !current_user.present? || !@team.users.include?(current_user)
            redirect_to @team, notice: 'Only team admins can edit or destroy teams.'
        else
          #check if they are admin
          # if !UserTeam.where(:user_id => user.id, :team_id => team.id).first.admin
        end
    end
end