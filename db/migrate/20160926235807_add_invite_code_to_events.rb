class AddInviteCodeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :invitecode, :string
  end
end
