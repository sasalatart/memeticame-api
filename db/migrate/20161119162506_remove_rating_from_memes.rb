class RemoveRatingFromMemes < ActiveRecord::Migration[5.0]
  def change
    remove_column :memes, :rating
  end
end
