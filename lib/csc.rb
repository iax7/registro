# frozen_string_literal: true

require "unaccent"

# Country, States, Cities search helper
module CSC
  class << self
    def countries(string)
      unaccented = string.unaccent.downcase
      countries = load_file(:countries)
      binding.pry
      countries.select { |c| c.unaccent.downcase =~ /#{unaccented}/ }
      # countries.grep /#{unaccented}/
    end

    def states(string)
      unaccented = string.unaccent.downcase
      states = load_file(:states_mx)
      states.select { |c| c.unaccent.downcase =~ /#{unaccented}/ }
      # countries.grep /#{unaccented}/
    end

    def cities(string)
      unaccented = string.unaccent.downcase
      cities = load_file(:cities)
      cities.select { |c| c.unaccent.downcase =~ /#{unaccented}/ }
      # countries.grep /#{unaccented}/
    end

    private

    # @param name [String]
    # @return [Hash]
    def load_file(name)
      path = File.expand_path("cscdb/#{name}.yml", __dir__)
      YAML.safe_load(File.read(path))
    end
  end
end
