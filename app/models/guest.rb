# frozen_string_literal: true

# Guest Model
class Guest < ApplicationRecord
  after_initialize :init
  before_validation :normalize, :on => [:create, :update]
  after_save :registry_totals

  belongs_to :registry, optional: false

  enum relation: {
    me: 0,
    family: 1,
    friend: 2,
    other: 3
  }

  validates :name,
            :lastname,
            :nick,
            presence: true

  validates :age,
            presence: true,
            numericality: true

  validates :fu_v1, :fu_v2, :fu_v3,
            :fu_s1, :fu_s2, :fu_s3,
            :fu_d1, :fu_d2, :fu_d3,
            :fu_l1, :fu_l2, :fu_l3,
            :tu_v1, :tu_v2,
            :tu_s1, :tu_s2,
            :tu_d1, :tu_d2,
            :tu_l1, :tu_l2,
            :lu_v, :lu_s, :lu_d, :lu_l,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }

  def self.relations_to_show
    visible_relations = relations.reject { |k| k == "me" }
    visible_relations.transform_keys { |k| I18n.t ".#{k}", scope: "helpers.label.guest.relations" }
  end

  def relation_t
    I18n.t(".#{relation}", scope: "helpers.label.guest.relations")
  end

  def full_name(is_last_first: true)
    is_last_first ? "#{lastname}, #{name}" : "#{name} #{lastname}"
  end

  def female?
    !is_male
  end

  def adult?
    age >= Event.current.adult_age
  end

  def child?
    (age < Event.current.adult_age) && (age >= 5)
  end

  def assist_cost
    costs_per_service :assist
  end

  def food_cost
    food_attr = attributes.select { |k, _| k.to_s.match(/^f_[vsdl]\d$/) }
    requested = food_attr.select { |_, v| v }
    requested.size * costs_per_service(:food)
  end

  def lodging_cost
    lodging_attr = attributes.select { |k, _| k.to_s.match(/^l_[vsdl]$/) }
    requested = lodging_attr.select { |_, v| v }
    requested.size * costs_per_service(:lodging)
  end

  def transport_cost
    trans_attr = attributes.select { |k| k.to_s.match(/^t_[vsdl]\d$/) }
    requested = trans_attr.select { |_, v| v }
    requested.size * costs_per_service(:transport)
  end

  ##
  # Sum of all costs
  # @return [Integer]
  def total
    (
      assist_cost +
      food_cost +
      lodging_cost +
      transport_cost
    )
  end

  ##
  # @param [Symbol] service - possible values: :assist, :food, :lodging, :transport
  # @return [Integer] price assigned for the service
  def costs_per_service(service)
    # 1 is Adult
    # 0 is Child
    # -1 is Infant
    age_type = if    adult? then 1
               elsif child? then 0
               else  -1
               end

    Event.current.costs_per_service service, age_type
  end

  private

  def init
    self.relation ||= Guest.relations[:family]
    self.is_male      = true  if is_male.nil?
    self.is_medicated = false if is_medicated.nil?
    self.is_pregnant  = false if is_pregnant.nil?
    # Requested Services
    self.f_v1  = false if f_v1.nil?
    self.f_v2  = false if f_v2.nil?
    self.f_v3  = false if f_v3.nil?
    self.f_s1  = false if f_s1.nil?
    self.f_s2  = false if f_s2.nil?
    self.f_s3  = false if f_s3.nil?
    self.f_d1  = false if f_d1.nil?
    self.f_d2  = false if f_d2.nil?
    self.f_d3  = false if f_d3.nil?
    self.f_l1  = false if f_l1.nil?
    self.f_l2  = false if f_l2.nil?
    self.f_l3  = false if f_l3.nil?
    self.t_v1  = false if t_v1.nil?
    self.t_v2  = false if t_v2.nil?
    self.t_s1  = false if t_s1.nil?
    self.t_s2  = false if t_s2.nil?
    self.t_d1  = false if t_d1.nil?
    self.t_d2  = false if t_d2.nil?
    self.t_l1  = false if t_l1.nil?
    self.t_l2  = false if t_l2.nil?
    self.l_v   = false if l_v.nil?
    self.l_s   = false if l_s.nil?
    self.l_d   = false if l_d.nil?
    self.l_l   = false if l_l.nil?
    # Used Services
    self.fu_v1 ||= 0
    self.fu_v2 ||= 0
    self.fu_v3 ||= 0
    self.fu_s1 ||= 0
    self.fu_s2 ||= 0
    self.fu_s3 ||= 0
    self.fu_d1 ||= 0
    self.fu_d2 ||= 0
    self.fu_d3 ||= 0
    self.fu_l1 ||= 0
    self.fu_l2 ||= 0
    self.fu_l3 ||= 0
    self.tu_v1 ||= 0
    self.tu_v2 ||= 0
    self.tu_s1 ||= 0
    self.tu_s2 ||= 0
    self.tu_d1 ||= 0
    self.tu_d2 ||= 0
    self.tu_l1 ||= 0
    self.tu_l2 ||= 0
    self.lu_v  ||= 0
    self.lu_s  ||= 0
    self.lu_d  ||= 0
    self.lu_l  ||= 0
  end

  def normalize
    self.name = name.titleize.squish
    self.lastname = lastname.titleize.squish
    self.nick = nick.titleize.squish
    self.l_room = l_room&.squish
  end

  # :nocov:
  def registry_totals
    # This method saves if the result is different than saved
    registry.totals
  end
  # :nocov:
end
