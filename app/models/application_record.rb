# frozen_string_literal: true

# Use this class to extend the Models
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
