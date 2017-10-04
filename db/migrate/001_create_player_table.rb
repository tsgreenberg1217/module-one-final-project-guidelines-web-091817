class CreatePlayerTable < ActiveRecord::Migration[4.2]
  def change
    create_table :players do |t|
      t.string :username
      t.integer :total_score
      t.string :XorO
    end
  end
end
