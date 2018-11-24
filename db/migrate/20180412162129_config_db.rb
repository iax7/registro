class ConfigDb < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'
    enable_extension 'unaccent'
    execute 'CREATE TEXT SEARCH CONFIGURATION es ( COPY = spanish );'
    execute 'ALTER TEXT SEARCH CONFIGURATION es ALTER MAPPING FOR hword, hword_part, word WITH unaccent, spanish_stem;'
  end
end
