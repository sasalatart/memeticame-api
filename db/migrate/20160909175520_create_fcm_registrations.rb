class CreateFcmRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :fcm_registrations do |t|
      t.references :user, foreign_key: true
      t.string :registration_token

      t.timestamps
    end
  end
end
