class AddDescriptionAndAvatarToEvents < ActiveRecord::Migration
    def change
        add_column :events, :description, :string
        add_attachment :events, :avatar
    end
end
