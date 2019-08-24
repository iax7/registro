class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :registry, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :amount, null: false
      t.integer :kind, null: false, default: 0

      t.timestamps
    end
  end
end
