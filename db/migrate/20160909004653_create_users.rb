class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone_number
      t.string :password_digest
      t.string :token

      t.timestamps
    end
  end
end
