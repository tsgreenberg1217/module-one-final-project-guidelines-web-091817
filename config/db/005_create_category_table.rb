class CreateCategoryTable < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      #round based/survival
      t.string :name
    end
  end
end
