class CreateUserTeams < ActiveRecord::Migration
  def change
    create_table :user_teams do |t|
      t.integer :user_id
      t.integer :team_id
      t.boolean :admin, default: false

      t.timestamps null: false
    end
  end
end
