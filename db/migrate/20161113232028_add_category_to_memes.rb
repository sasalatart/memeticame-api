class AddCategoryToMemes < ActiveRecord::Migration[5.0]
  def change
    add_reference :memes, :category, foreign_key: true
  end
end
