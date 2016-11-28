class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.date :earlist_date
      t.date :furthest_date
      t.timestamps null: false
    end
  end
end
