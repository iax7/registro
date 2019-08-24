class UserAddGuestsHistory < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :guest_history, :jsonb, null: false, default: {}
  end
end
