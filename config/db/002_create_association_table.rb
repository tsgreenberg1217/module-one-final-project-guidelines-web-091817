class CreateAssociationTable < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.integer :player_id
      t.integer :game_id
      t.integer :question_id
      t.integer :score
    end
  end
end
