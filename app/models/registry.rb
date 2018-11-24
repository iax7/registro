# frozen_string_literal: true

# Registry Model
class Registry < ApplicationRecord
  after_initialize :init
  before_create :create_owner_as_guest

  belongs_to :user, required: true
  belongs_to :event, required: true
  has_many :guests

  scope :current, ->(user_id) { includes(:user, :guests).where(event_id: Event.current.id, user_id: user_id) }
  # scope :un_paid, -> { where('amount_debt + amount_offering <> amount_paid') }

  def grand_total
    amount_debt + amount_offering
  end

  def amount_remaining
    grand_total - amount_paid
  end

  def paid?
    amount_remaining <= 0
  end

  def totals
    calculate if !@is_calculated || changed?
    @totals
  end

  def counts
    calculate if !@is_calculated || changed?
    @counts
  end

  private

  def init
    self.is_confirmed  ||= false
    self.is_present    ||= false
    self.is_notified   ||= false

    self.amount_debt     ||= 0
    self.amount_paid     ||= 0
    self.amount_offering ||= 0

    @is_calculated = false
  end

  def create_owner_as_guest
    guests.build name: user.name,
                 lastname: user.lastname,
                 nick: user.nick,
                 age: user.age,
                 is_male: user.is_male,
                 relation: Guest.relations[:me]
  end

  ### Important
  # This function is trigger in registries#show
  # (which is default when returning from saving a guest)
  # And in registries#index to view all registries.
  # This updates the amount_debt if changed from DB value
  ###
  def calculate
    @totals = {
      pregnant:  0,
      medicated: 0,
      assist:    0,
      food:      0,
      trans:     0,
      lodging:   0,
      total:     0
    }
    keys = %i[f_v1 f_v2 f_v3
              f_s1 f_s2 f_s3
              f_d1 f_d2 f_d3
              f_l1 f_l2 f_l3
              t_v1 t_v2
              t_s1 t_s2
              t_d1 t_d2
              t_l1 t_l2
              l_v l_s l_d l_l]
    @counts = Hash[keys.collect { |key| [key, 0] }].with_indifferent_access

    guests.each do |g|
      @totals[:pregnant] += g.is_pregnant ? 1 : 0
      @totals[:medicated] += g.is_medicated ? 1 : 0
      @totals[:assist] += g.assist_cost
      @totals[:food] += g.food_cost
      @totals[:trans] += g.transport_cost
      @totals[:lodging] += g.lodging_cost
      @totals[:total] += g.total

      attr_true = g.attributes.select { |k, v| k.to_s.match(/^._\w\d?$/) && v }
      attr_true.each { |k, _| @counts[k.to_sym] += 1 }
    end
    @is_calculated = true

    if amount_debt != @totals[:total]
      self.amount_debt = @totals[:total]
      save!
    end
  end
end
