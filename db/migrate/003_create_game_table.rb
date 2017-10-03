class CreateGameTable < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.integer :player_id
    end
  end
end
