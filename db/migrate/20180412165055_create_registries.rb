class CreateRegistries < ActiveRecord::Migration[5.2]
  def change
    create_table :registries do |t|
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true
      t.text :comments
      t.boolean :is_confirmed
      t.boolean :is_present
      t.boolean :is_notified
      t.integer :amount_debt
      t.integer :amount_paid
      t.integer :amount_offering

      t.timestamps
    end
  end
end
