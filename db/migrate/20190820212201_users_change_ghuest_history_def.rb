class UsersChangeGhuestHistoryDef < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :guest_history, :jsonb, null: false, default: []
  end
end
