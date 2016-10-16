class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.boolean :private
      t.string :hexcolor
      t.string :invitecode

      t.timestamps null: false
    end
  end
end
