class CreatePlayerTable < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :username
      t.integer :question_id
    end
  end
end
