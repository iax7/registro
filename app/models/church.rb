class Church < ActiveRecord::Base
  before_validation :normalize_name, on: [ :create, :update ]
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false }

  def self.check_add(name)
    church = Church.where 'lower(name) = ?', name.downcase
    if church.first.nil?
      church = Church.new
      church.name = name
      church.save
      true
    else
      false
    end
  end

  private
    def normalize_name
      self.name = self.name.titleize
    end

end