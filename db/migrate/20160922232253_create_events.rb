class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :finish_date
      t.string :start_location
      t.string :end_location

      t.timestamps null: false
    end
  end
end
