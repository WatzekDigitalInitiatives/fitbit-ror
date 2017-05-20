class ChangeEventDistanceToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :distance, :float
  end
end
