class Guest < ActiveRecord::Base
  before_validation :normalize_name, on: [ :create, :update ]
  after_initialize :init
  belongs_to :person, required: true

  validates :name,
            :nickname,
            presence: true

  validates :age,
            presence: true,
            numericality: true

  enum relation: { family: 0, friend: 1, other: 2 }

  def gender
    if ismale
      'Hombre'
    else
      'Mujer'
    end
  end

  def is_adult
    self.age >= Rails.application.config.reg_adult_age
  end

  def self.i18n_relations(hash = {})
    relations.keys.each { |key| hash[I18n.t("activerecord.attributes.guest.relations.#{key}")] = key }
    hash
  end

  def relation_locale
    #I18n.t("activerecord.attributes.guest.relations.#{self.relation}")
    I18n.t self.relation, scope: [ :activerecord, :attributes, :guest, :relations ]
  end

  private
    def init
      self.ismale = true if self.ismale.nil?
      self.relation ||= 0
    end

    def normalize_name
      self.name = self.name.titleize
    end
end
