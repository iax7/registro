class CreateGuests < ActiveRecord::Migration[5.2]
  def change
    create_table :guests do |t|
      t.references :registry, foreign_key: true

      t.string :name    , null: false
      t.string :lastname, null: false
      t.string :nick    , null: false
      t.boolean :is_male, null: false
      t.integer :age    , null: false
      t.integer :relation
      t.boolean :is_pregnant , null: false, default: false
      t.boolean :is_medicated, null: false, default: false

      t.boolean :f_v1, null: false, default: false
      t.boolean :f_v2, null: false, default: false
      t.boolean :f_v3, null: false, default: false
      t.boolean :f_s1, null: false, default: false
      t.boolean :f_s2, null: false, default: false
      t.boolean :f_s3, null: false, default: false
      t.boolean :f_d1, null: false, default: false
      t.boolean :f_d2, null: false, default: false
      t.boolean :f_d3, null: false, default: false
      t.boolean :f_l1, null: false, default: false
      t.boolean :f_l2, null: false, default: false
      t.boolean :f_l3, null: false, default: false
      t.boolean :t_v1, null: false, default: false
      t.boolean :t_v2, null: false, default: false
      t.boolean :t_s1, null: false, default: false
      t.boolean :t_s2, null: false, default: false
      t.boolean :t_d1, null: false, default: false
      t.boolean :t_d2, null: false, default: false
      t.boolean :t_l1, null: false, default: false
      t.boolean :t_l2, null: false, default: false
      t.boolean :l_v , null: false, default: false
      t.boolean :l_s , null: false, default: false
      t.boolean :l_d , null: false, default: false
      t.boolean :l_l , null: false, default: false
      t.string :l_room

      t.timestamps
    end
  end
end
