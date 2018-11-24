class AddPaidBy < ActiveRecord::Migration[5.2]
  def change
    add_column :registries, :paid_by, :bigint
  end
end
