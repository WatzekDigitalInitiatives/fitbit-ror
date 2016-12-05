class EventsController < ApplicationController
    before_action :set_event, only: [:show, :edit, :update, :destroy]
    before_action :check_private_event_users, only: [:show]
    before_action :authenticate_user!, only: [:new, :myevents]
    before_action :check_user_event, only: [:edit, :destroy]

    # GET /events
    # GET /events.json
    def index
        @user = current_user
        @events = Event.all
        @events.each do |event|
            event.static_map_preview = [
                'https://maps.googleapis.com/maps/api/staticmap?&size=955x120&maptype=terrain',
                '&markers=color:green%7Clabel:A%7C', event.start_location,
                '&markers=color:red%7Clabel:B%7C', event.end_location,
                '&path=', event.start_location, '|', event.end_location,
                '&scale=2', '&key=', ENV['GOOGLE_API_KEY']
            ].join
        end
    end

    def myevents
        @user = current_user
        @participating_events = current_user.events
        @user_teams = current_user.teams
        @user_teams.each do |team|
          @eve = team.events
          @eve.each do |event|
            if !@participating_events.include?(event)
              @participating_events << event if event
            end
          end
        end

        @participating_events.each do |event|
            event.static_map_preview = [
                'https://maps.googleapis.com/maps/api/staticmap?&size=955x120&maptype=terrain',
                '&markers=color:green%7Clabel:A%7C', event.start_location,
                '&markers=color:red%7Clabel:B%7C', event.end_location,
                '&path=', event.start_location, '|', event.end_location,
                '&scale=2', '&key=', ENV['GOOGLE_API_KEY']
            ].join
        end
    end

    # GET /events/1
    # GET /events/1.json
    def show

      set_date(params, @event.start_date, @event.finish_date)

      @user = current_user
      if @event.team_event

        # Set markers for data from start_date till date
        event_id = @event.id
        date = @date
        @markers = set_team_markers(event_id, date)
        @markers = @markers.sort_by { |h| h[:total_steps] }.reverse

        # Set total_steps for that date
        @teams = @event.teams
        @teams.each do |team|
          team.total_steps = 0
          team.users.each do |user|
            @activity = Activity.find_by(entry_date: @date, user_id: user.id)
            if @activity
              team.total_steps += @activity.steps
              user.steps = @activity.steps
              user.goal_met = @activity.goal_met
            else
              team.total_steps += 0
              user.steps = "Steps not registered"
              user.goal_met = false
            end
          end
        end

        @teams = @teams.sort_by { |h| h[:total_steps] }.reverse

      else

        # Set markers for data from start_date till date
        event_id = @event.id
        date = @date
        @markers = set_user_markers(event_id, date)
        @markers = @markers.sort_by { |h| h[:total_steps] }.reverse

        # Set total_steps for that date
        @users = @event.users
        @users.each do |user|
          @activity = Activity.find_by(entry_date: @date, user_id: user.id)
          if @activity
            user.steps = @activity.steps
            user.goal_met = @activity.goal_met
          else
            user.steps = 0
            user.goal_met = false
          end
        end
        @users = @users.sort_by { |h| h[:steps] }.reverse

      end

      @event.static_map_preview = [
              'https://maps.googleapis.com/maps/api/staticmap?&size=955x120&maptype=terrain',
              '&markers=color:green%7Clabel:A%7C', @event.start_location,
              '&markers=color:red%7Clabel:B%7C', @event.end_location,
              '&path=', @event.start_location, '|', @event.end_location,
              '&scale=2', '&key=', ENV['GOOGLE_API_KEY']
      ].join
      @mapArgs = {'mapID' => 'showEventMap', 'origin' => @event.start_location, 'destination' => @event.end_location, 'markers' => @markers}
      gon.mapArgs = @mapArgs

      # Date Picker is reducing each date by 1 day so adding 1 day to make it right, REALLY DONT KNOW WHY!
      gon.start_date = @event.start_date+1.day
      gon.finish_date = @event.finish_date+1.day
    end

    # GET /events/new
    def new
        @user = current_user
        @event = Event.new
        @teams = Team.where(createdby: @user.id).all
        @edit = false
    end

    # GET /events/1/edit
    def edit
        @user = current_user
        @teams = Team.where(createdby: @user.id).all
        @edit = true
    end

    # POST /events
    # POST /events.json
    def create
        @event = Event.new(event_params)
        @event.createdby = current_user.id
        @event.invitecode = [*('A'..'Z'), *('0'..'9')].sample(6).join

        respond_to do |format|
            if @event.save
              if @event.team_event
                @team_event = TeamEvent.new
                @team_event.team_id = params[:team_id]
                @team_event.event_id = @event.id
                if @team_event.save
                    @team = Team.find(params[:team_id])
                    @team.users.each do |user|
                      set_subscription_date(user.id, @event.start_date, @event.finish_date)
                      create_user_subscription(user)
                    end
                    format.html { redirect_to @event, notice: 'Event was successfully created.' }
                    format.json { render :show, status: :created, location: @event }
                end
              else
                @user_event = UserEvent.new
                @user_event.user_id = current_user.id
                @user_event.event_id = @event.id
                if @user_event.save
                    set_subscription_date(current_user.id, @event.start_date, @event.finish_date)
                    create_user_subscription(current_user)
                    format.html { redirect_to @event, notice: 'Event was successfully created.' }
                    format.json { render :show, status: :created, location: @event }
                end
              end
            else
                format.html { render :new }
                format.json { render json: @event.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /events/1
    # PATCH/PUT /events/1.json
    def update
        respond_to do |format|
            if @event.update(event_params)
                format.html { redirect_to @event, notice: 'Event was successfully updated.' }
                format.json { render :show, status: :ok, location: @event }
            else
                format.html { render :edit }
                format.json { render json: @event.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /events/1
    # DELETE /events/1.json
    def destroy
        @event.destroy
        respond_to do |format|
            format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_event
        @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
        params.require(:event).permit(:name, :start_date, :finish_date, :start_location, :end_location, :private, :team_event, :team_id, :avatar, :description)
    end

    # Checks if user owns the event to edit and destroy event
    def check_user_event
        if !current_user.present? || current_user.id != @event.createdby
            redirect_to @event, notice: 'You dont have permissions to edit this event.'
        end
    end

    # Checks if the event is private and only allow creator or people who joined to see the event
    def check_private_event_users
        if @event.private && !current_user.present?
            redirect_to events_path, notice: 'You dont have access to this event. Please try after logging in.'
            return
        end
        if @event.private && current_user.id != @event.createdby
            unless @event.users.include?(current_user)
                redirect_to events_path, notice: 'You dont have permissions to view this event.'
            end
        end
    end

    def set_date (params, start_date, finish_date)
      today = Date.today.strftime("%Y-%m-%d")
      today = Date.parse today

      if (params[:date].present?)
        @date = Date.parse params[:date]
      else
        @date = today
      end

      if @event.start_date > @date || @date > @event.finish_date
        if today > @event.finish_date
          @date = @event.finish_date
        elsif today < @event.start_date
          @date = @event.start_date
        else
          @date = today
        end
      end
    end

    def set_team_markers(event_id, finish_date)
      @event = Event.find(event_id)
      @teams = @event.teams
      start_date = @event.start_date
      @markers = []
      @teams.each do |team|
        @data = {"total_steps" => 0, "hexcolor" => team.hexcolor, "name" => team.name }
        team.users.each do |user|
          (start_date..finish_date).each do |date|
            @activity = Activity.find_by(entry_date: date, user_id: user.id)
            if @activity
              @data["total_steps"] += @activity.steps
            else
              @data["total_steps"] += 0
            end
          end
        end
      @markers << @data
      end
      return @markers
    end

    def set_user_markers(event_id, finish_date)
      @event = Event.find(event_id)
      @users = @event.users
      start_date = @event.start_date
      @markers = []
      @users.each do |user|
        @data = {"total_steps" => 0, "hexcolor" => user.hexcolor, "name" => user.name }
        (start_date..finish_date).each do |date|
          @activity = Activity.find_by(entry_date: date, user_id: user.id)
          if @activity
            @data["total_steps"] += @activity.steps
          else
            @data["total_steps"] += 0
          end
        end
      @markers << @data
      end
      return @markers
    end

end
