class AddNameToMemes < ActiveRecord::Migration[5.0]
  def change
    add_column :memes, :name, :string
  end
end
