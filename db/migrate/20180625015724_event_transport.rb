class EventTransport < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :t_v
    remove_column :events, :t_s
    remove_column :events, :t_d
    remove_column :events, :t_l

    add_column :events, :t_v1, :integer, default: 0
    add_column :events, :t_v2, :integer, default: 0
    add_column :events, :t_s1, :integer, default: 0
    add_column :events, :t_s2, :integer, default: 0
    add_column :events, :t_d1, :integer, default: 0
    add_column :events, :t_d2, :integer, default: 0
    add_column :events, :t_l1, :integer, default: 0
    add_column :events, :t_l2, :integer, default: 0
  end
end
