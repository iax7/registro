class AddServicesUsed < ActiveRecord::Migration[5.2]
  def change
    add_column :guests, :fu_v1, :integer, null: false, default: 0
    add_column :guests, :fu_v2, :integer, null: false, default: 0
    add_column :guests, :fu_v3, :integer, null: false, default: 0
    add_column :guests, :fu_s1, :integer, null: false, default: 0
    add_column :guests, :fu_s2, :integer, null: false, default: 0
    add_column :guests, :fu_s3, :integer, null: false, default: 0
    add_column :guests, :fu_d1, :integer, null: false, default: 0
    add_column :guests, :fu_d2, :integer, null: false, default: 0
    add_column :guests, :fu_d3, :integer, null: false, default: 0
    add_column :guests, :fu_l1, :integer, null: false, default: 0
    add_column :guests, :fu_l2, :integer, null: false, default: 0
    add_column :guests, :fu_l3, :integer, null: false, default: 0
    add_column :guests, :tu_v1, :integer, null: false, default: 0
    add_column :guests, :tu_v2, :integer, null: false, default: 0
    add_column :guests, :tu_s1, :integer, null: false, default: 0
    add_column :guests, :tu_s2, :integer, null: false, default: 0
    add_column :guests, :tu_d1, :integer, null: false, default: 0
    add_column :guests, :tu_d2, :integer, null: false, default: 0
    add_column :guests, :tu_l1, :integer, null: false, default: 0
    add_column :guests, :tu_l2, :integer, null: false, default: 0
    add_column :guests, :lu_v , :integer, null: false, default: 0
    add_column :guests, :lu_s , :integer, null: false, default: 0
    add_column :guests, :lu_d , :integer, null: false, default: 0
    add_column :guests, :lu_l , :integer, null: false, default: 0
  end
end
