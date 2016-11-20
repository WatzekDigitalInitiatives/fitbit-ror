class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.date :entry_date
      t.integer :steps
      t.integer :goal
      t.boolean :goal_met, default: false
      t.timestamps null: false
    end
  end
end
