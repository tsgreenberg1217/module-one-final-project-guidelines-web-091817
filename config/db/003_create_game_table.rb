class CreateGameTable < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.string :type
    end
  end
end
