# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  before_validation :normalize, :on => [:create, :update]
  after_initialize :init
  before_create :create_registry
  after_update :update_guest_self

  validate :user_is_adult

  has_secure_password
  has_many :registries

  has_one :current, -> { where event_id: Event.current.id }, class_name: 'Registry'

  validates :name,
            :lastname,
            :nick,
            :country,
            :state,
            :city,
            presence: true

  validates :email,
            presence: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            uniqueness: { case_sensitive: false }

  validates :phone,
            length: { minimum: 10 },
            format: { with: /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/ }

  validates :dob,
            presence: true

  validates :password,
            length: { minimum: 6 },
            allow_nil: true

  validates :password_digest,
            confirmation: true,
            on: :create

  scope :find_by_email_hashed, ->(hash) { where 'md5(email) = ?', hash }

  def age
    now = Time.now.utc.to_date
    now.year - dob.year - (now.month > dob.month || (now.month == dob.month && now.day >= dob.day) ? 0 : 1)
  end

  def location
    country.present? ? %(#{city}, #{state}, #{country}) : 'N/A'
  end

  def full_name(is_last_first = true)
    is_last_first ? "#{lastname}, #{name}" : "#{name} #{lastname}"
  end

  # password reset ----------------------------------------
  # TODO: Implement Rails 5 has_secure_token
  # migration: t.token :reset_token
  # user.reset_token; user.regenerate_reset_token
  # has_secure_token(:reset_token)
  def set_password_reset
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    save!
  end

  private

  def init
    self.is_male  = true if is_male.nil?
    self.is_admin = false if is_admin.nil? # DON'T EVER CHANGE THIS
    # self.dob      ||= Date.today
  end

  def normalize
    self.name = name.titleize.strip.squish
    self.lastname = lastname.titleize.strip.squish
    self.nick = nick.strip.squish
    self.phone = phone.scan(/\d/).join ''
    self.email = email.downcase.strip
    self.country = country.titleize.strip.squish
    self.state = state.titleize.strip.squish
    self.city = city.titleize.strip.squish
  end

  def create_registry
    # Makes sure it always has a registry if none is defined
    registries.build(event: Event.current) if registries.size <= 0
  end

  def update_guest_self
    # registry = Registry.find_by event: Event.current, user: self
    # guest_me = registry.guests.me.first
    guest_me = current.guests.me.first

    attr_exceptions = %w[id created_at updated_at]

    common_attr = attributes.select do |key, _|
      guest_me.attribute_names.include?(key) unless attr_exceptions.include?(key)
    end
    common_attr['age'] = age
    guest_me.assign_attributes common_attr
    guest_me.save if guest_me.changed?
  end

  def user_is_adult
    errors.add(:dob, 'Debes tener mas de 18 años') if !dob.nil? && age < 18
  end
end
