class CreatePlayerTable < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.integer :question_id
    end
  end
end
