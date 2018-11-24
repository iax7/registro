class AddJsonbToEvent < ActiveRecord::Migration[5.2]
  def change
    #enable_extension 'citext' Must be enabled
    add_column :events, :settings, :jsonb, null: false, default: {}
    add_index :events, :settings, using: :gin
  end
end
