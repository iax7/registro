class State < ActiveRecord::Base
  validates :name,
            presence: true
end
