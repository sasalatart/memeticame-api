class CreateMemes < ActiveRecord::Migration[5.0]
  def change
    create_table :memes do |t|
      t.integer :owner_id
      t.timestamps
    end
  end
end
