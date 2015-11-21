class Hotel < ActiveRecord::Base
  after_initialize :init

  validates :name,
            presence: true
  validates :address,
            presence: true
  validates :phone,
            presence: true

  def init
    self.has_discount = false if self.has_discount.nil?
  end
end
