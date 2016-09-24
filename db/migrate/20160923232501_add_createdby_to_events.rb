class AddCreatedbyToEvents < ActiveRecord::Migration
  def change
    add_column :events, :createdby, :integer
  end
end
