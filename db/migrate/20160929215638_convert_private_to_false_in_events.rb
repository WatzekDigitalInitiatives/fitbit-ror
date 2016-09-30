class ConvertPrivateToFalseInEvents < ActiveRecord::Migration
  def change
    change_column :events, :private, :boolean, default: false
  end
end
