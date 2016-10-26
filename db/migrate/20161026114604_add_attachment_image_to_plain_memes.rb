class AddAttachmentImageToPlainMemes < ActiveRecord::Migration
  def self.up
    change_table :plain_memes do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :plain_memes, :image
  end
end
