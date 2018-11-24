# frozen_string_literal: true

# Country, States, Cities search helper
module CSC
  require 'unaccent'

  def self.countries(string)
    unaccented = string.unaccent.downcase
    countries = YAML.safe_load(File.read(File.expand_path('cscdb/countries.yml', __dir__)))
    countries.select { |c| c.unaccent.downcase =~ /#{unaccented}/ }
    # countries.grep /#{unaccented}/
  end

  def self.states(string)
    unaccented = string.unaccent.downcase
    states = YAML.safe_load(File.read(File.expand_path('cscdb/states_mx.yml', __dir__)))
    states.select { |c| c.unaccent.downcase =~ /#{unaccented}/ }
    # countries.grep /#{unaccented}/
  end

  def self.cities(string)
    unaccented = string.unaccent.downcase
    cities = YAML.safe_load(File.read(File.expand_path('cscdb/cities.yml', __dir__)))
    cities.select { |c| c.unaccent.downcase =~ /#{unaccented}/ }
    # countries.grep /#{unaccented}/
  end
end
