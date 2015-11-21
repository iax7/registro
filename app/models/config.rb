class Config < ActiveRecord::Base
  after_initialize :init

  validates :foodcost, :allocationcost, :max_food, :max_allocation,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }

  def init
    self.foodcost       ||= 0
    self.allocationcost ||= 0
    self.max_food       ||= 0
    self.max_allocation ||= 0
    self.fooddeadline   ||= Date.today + 3.months
    self.allocationdeadline ||= Date.today + 3.months
  end
end
