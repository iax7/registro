class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.integer :f_v1
      t.integer :f_v2
      t.integer :f_v3
      t.integer :f_s1
      t.integer :f_s2
      t.integer :f_s3
      t.integer :f_d1
      t.integer :f_d2
      t.integer :f_d3
      t.integer :f_l1
      t.integer :f_l2
      t.integer :f_l3
      t.integer :t_v
      t.integer :t_s
      t.integer :t_d
      t.integer :t_l
      t.integer :l_v
      t.integer :l_s
      t.integer :l_d
      t.integer :l_l

      t.timestamps
    end
  end
end
