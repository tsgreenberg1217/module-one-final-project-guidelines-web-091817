class CreateOveralSentimentTable < ActiveRecord::Migration
  def change
    create_table :speaches do |t|
      t.string :title
      t.integer :candidate_id
    end
  end
end
