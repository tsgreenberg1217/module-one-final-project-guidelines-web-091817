class CreateGameTable < ActiveRecord::Migration[4.2]
  def change
    create_table :games do |t|
      t.string :mode
      t.string :difficulty
      t.timestamps
    end
  end
end
