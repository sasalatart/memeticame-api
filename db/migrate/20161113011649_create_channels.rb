class CreateChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :channels do |t|
      t.integer :owner_id
      t.string :name

      t.timestamps
    end
  end
end
