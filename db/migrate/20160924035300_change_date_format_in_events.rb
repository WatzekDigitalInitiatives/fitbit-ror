class ChangeDateFormatInEvents < ActiveRecord::Migration
  def change
    change_column :events, :start_date, :date
    change_column :events, :finish_date, :date
  end
end
