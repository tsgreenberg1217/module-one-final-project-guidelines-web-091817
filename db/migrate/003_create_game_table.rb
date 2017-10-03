class CreateGameTable < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :type
      t.string :difficulty
      t.timestamps
    end
  end
end
