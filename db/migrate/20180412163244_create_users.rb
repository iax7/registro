class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :lastname
      t.string :nick
      t.boolean :is_male, :null => false, :default => true
      t.date :dob
      t.string :email, null: false, unique: true
      t.string :phone
      t.boolean :is_admin, default: false
      t.string :password_digest
      t.string :password_reset_token
      t.datetime :password_reset_sent_at

      t.timestamps
    end
    add_index :users, :email
  end
end
