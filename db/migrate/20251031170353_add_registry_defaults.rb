class AddRegistryDefaults < ActiveRecord::Migration[7.2]
  def change
    change_column_default :registries, :is_confirmed, from: nil, to: false
    change_column_default :registries, :is_present, from: nil, to: false
    change_column_default :registries, :is_notified, from: nil, to: false

    change_column_null    :registries, :is_confirmed, false, false
    change_column_null    :registries, :is_present, false, false
    change_column_null    :registries, :is_notified, false, false

    change_column_default :registries, :amount_debt, from: nil, to: 0
    change_column_default :registries, :amount_paid, from: nil, to: 0
    change_column_default :registries, :amount_offering, from: nil, to: 0
  end
end
