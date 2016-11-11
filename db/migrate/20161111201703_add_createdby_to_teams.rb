class AddCreatedbyToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :createdby, :integer
  end
end
