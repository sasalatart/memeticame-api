class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.references :chat, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end
