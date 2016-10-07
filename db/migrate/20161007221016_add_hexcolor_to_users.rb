class AddHexcolorToUsers < ActiveRecord::Migration
    def change
        add_column :users, :hexcolor, :string
    end
end
