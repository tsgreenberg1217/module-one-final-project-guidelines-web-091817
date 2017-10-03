class CreateGameTable < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.datetime :timestamps
    end
  end
end
