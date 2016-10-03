class AddIsTeamFieldToEventsTable < ActiveRecord::Migration
  def change
    add_column :events, :team_event, :boolean, default: false
  end
end
