class CreateMemeTags < ActiveRecord::Migration[5.0]
  def change
    create_table :meme_tags do |t|
      t.references :meme, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
