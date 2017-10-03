class CreateQuestionTable < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :type
      t.string :difficulty
      t.integer :score
      t.integer :category_id
    end
  end
end
