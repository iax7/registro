# frozen_string_literal: true

# Payment Model
class Payment < ApplicationRecord
  belongs_to :registry, optional: false
  belongs_to :user, optional: false

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
    kinds.map { |k, v| [I18n.t(".#{k}", scope: 'helpers.label.payments.kinds'), v] }.to_h
  end

  def kind_t
    I18n.t(".#{kind}", scope: 'helpers.label.payments.kinds')
  end
end
