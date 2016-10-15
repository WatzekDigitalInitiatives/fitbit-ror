class AddDistanceToEvents < ActiveRecord::Migration
  def change
    add_column :events, :distance, :integer
  end
end
