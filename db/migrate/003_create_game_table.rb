class CreateGameTable < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :type
      t.integer :player_id
    end
  end
end
