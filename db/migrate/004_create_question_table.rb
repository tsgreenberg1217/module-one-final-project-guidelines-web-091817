class CreateQuestionTable < ActiveRecord::Migration[4.2]
  def change
    create_table :questions do |t|
      t.string :content #this is the question being asked
      t.string :correct_answer
      t.string :answer_type
      t.string :difficulty
      t.integer :score
      t.integer :category_id
    end
  end
end
