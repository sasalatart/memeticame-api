class AddRatingToMemes < ActiveRecord::Migration[5.0]
  def change
    add_column :memes, :rating, :decimal, default: 0
  end
end
