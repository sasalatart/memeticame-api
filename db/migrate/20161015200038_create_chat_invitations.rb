class CreateChatInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_invitations do |t|
      t.references :user, foreign_key: true
      t.references :chat, foreign_key: true

      t.timestamps
    end
  end
end
