class CreatePlainMemes < ActiveRecord::Migration[5.0]
  def change
    create_table :plain_memes do |t|

      t.timestamps
    end
  end
end
