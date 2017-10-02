class CreateCandidateTable < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.integer :writter_id
    end
  end
end
