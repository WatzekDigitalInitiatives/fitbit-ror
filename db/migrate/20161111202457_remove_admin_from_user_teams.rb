class RemoveAdminFromUserTeams < ActiveRecord::Migration
  def change
    remove_column :user_teams, :admin
  end
end
