# frozen_string_literal: true

# Payment Model
class Payment < ApplicationRecord
  belongs_to :registry, required: true
  belongs_to :user, required: true

  validates :amount,
            :kind,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }

  enum kinds: {
    money: 0,
    gift: 1
  }

  def self.human_attribute_kinds
    Hash[kinds.map { |k, v| [I18n.t(".#{k}", scope: 'helpers.label.payments.kinds'), v] }]
  end

  def kind_t
    I18n.t(".#{kind}", scope: 'helpers.label.payments.kinds')
  end
end
