class CreateAssociationsTable < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.integer :player_id
      t.integer :game_id
      t.integer :question_id
    end
  end
end
