class CreateTeamEvents < ActiveRecord::Migration
  def change
    create_table :team_events do |t|
      t.integer :team_id
      t.integer :event_id

      t.timestamps null: false
    end
  end
end
