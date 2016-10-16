class AddAvatarAndMakePrivateDefaultToFalseForTeams < ActiveRecord::Migration
  def change
    add_attachment :teams, :avatar
    change_column :teams, :private, :boolean, default: false
  end
end
