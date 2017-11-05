require 'securerandom'
require 'digest'

class Person < ActiveRecord::Base
  before_validation :normalize_all, on: [ :create, :update ]
  before_create :create_password
  after_initialize :init
  after_validation :check_paid_amount, on: [ :create, :update ]

  #validates_presence_of :food, :allocation

  has_many :guests, :dependent => :delete_all
  accepts_nested_attributes_for :guests

  has_one :food, :dependent => :delete
  has_one :allocation, :dependent => :delete
  has_one :transport, :dependent => :delete

  validates :name,
            :lastname,
            :nickname,
            :church,
            :state,
            :city,
            presence: true

  validates :email,
            presence: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            uniqueness: { case_sensitive: false }

  validates :phone,
            length: { minimum: 10},
            format: { with: /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/ }
            #numericality: { only_integer: true }

  validates :password,
            confirmation: true,
            presence: true,
            on: :create

  validates :password_confirmation,
            presence: true,
            on: :create

  validates :age,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 12 }

  validates :amount_paid,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }

  validates :offering,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0,
                            allow_nil: true }

  def set_password(text)
    pass_str = "#{self.salt}$#{text}"
    self.password = Digest::SHA1.hexdigest(pass_str)
  end

  def validate_password(password)
    pass_str = "#{self.salt}$#{password}"
    pass_hashed = Digest::SHA1.hexdigest(pass_str)

    self.password == pass_hashed
  end

  def full_name(is_last_first = true)
    is_last_first ? "#{lastname}, #{name}" : "#{name} #{lastname}"
  end

  def total
    total = 0
    total += self.offering unless self.offering.nil?
    total += total_people_cost
    unless self.food.nil?
      total += self.food.total_cost
    end
    unless self.allocation.nil?
      total += self.allocation.total_cost
    end
    unless self.transport.nil?
      total += self.transport.total_cost
    end
    total
  end

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

  def validate_reset_password_token(token)
    msg = Rails.application.message_verifier(:password).verify token
    puts "Read Token: #{msg}"
    return false if msg.nil?
    email = msg[0]
    date = msg[1].to_datetime
    return nil if date < Time.now
    email == self.email # If emails match is valid
  end

  def get_reset_password_route
    id = Base64.urlsafe_encode64 self.id.to_s

    # Time Token
    date_str = 2.hours.from_now.to_s
    token_obj = [self.email, date_str]
    str = Rails.application.message_verifier(:password).generate token_obj
    ver = Base64.urlsafe_encode64 str

    "reset/#{id}/#{ver}"
  end

  def get_cancel_route
    email_hash = Digest::MD5.hexdigest(self.email)
    "cancel/#{email_hash}"
  end

  def assist_tostring
    friday = 'viernes'
    saturday = 'sábado'
    sunday = 'domingo'
    monday = 'lunes'
    result = ''
    result += "<strong class='viernes-text'>#{friday}</strong>, " if self.assist_v?
    result += "<strong class='sabado-text'>#{saturday}</strong>, " if self.assist_s?
    result += "<strong class='domingo-text'>#{sunday}</strong>, " if self.assist_d?
    result += "<strong class='lunes-text'>#{monday}</strong>, " if self.assist_l?
    return result.strip[0..-2]
  end

  def total_people
    self.guests.length + 1
  end

  def total_adults
    count = 0
    count += 1 if self.is_adult
    self.guests.each do |g|
      count += 1 if g.is_adult
    end
    count
  end

  def total_people_cost
    self.total_adults * Rails.application.config.reg_event_full_price
  end

  def is_paid
    amount_paid >= total
  end

  # Filters --------------------------------------
  scope :id,         -> (text) { where id: text }
  scope :lastname,   -> (text) { where 'lower(lastname) LIKE ?', "%#{text.downcase}%" }
  scope :church,     -> (text) { where 'lower(church) LIKE ?', "%#{text.downcase}%" }
  scope :city,       -> (text) { where 'lower(city) LIKE ?', "%#{text.downcase}%" }
  scope :state,      -> (text) { where 'lower(state) LIKE ?', "%#{text.downcase}%" }
  scope :changed_by, -> (text) { where changed_by: text }
  scope :is_admin,         -> (bool) { where isadmin: bool }
  scope :is_confirmed,     -> (bool) { where isconfirmed: bool }
  scope :is_not_confirmed, -> (bool) { where isconfirmed: !bool }
  scope :confirmed,        -> { where isconfirmed: true }
  scope :is_cancelled,     -> (bool) { where iscancelled: bool }
  scope :find_by_email_hashed, -> (hash) { where 'md5(email) = ?', hash }

  scope :adults, -> { where('age >= ?', Rails.application.config.reg_adult_age) }
  #def self.adults
  #  where('age >= ?', 12)
  #end

  scope :with_comments, -> { where.not(comments: '') }
  #def self.with_comments
  #  where.not(comments: '')
  #end

  def self.count_by_sex
    #select('ismale as sex, count(ismale)').group('ismale')
    confirmed.group(:ismale).count
  end

  def self.count_by_age
    # 'a' stands for Adults
    # 'c' stands for Children
    adult_age = Rails.application.config.reg_adult_age
    qry = <<-SQL
SELECT age, isconfirmed, count(1)
  FROM (
         SELECT 'a' AS age,
                isconfirmed
           FROM people
          WHERE age >= #{adult_age}
        UNION ALL
         SELECT 'c' AS age,
                isconfirmed
           FROM people
          WHERE age < #{adult_age}
        UNION ALL
         SELECT 'a' AS age,
                isconfirmed
           FROM guests g INNER JOIN
                people p ON g.person_id = p.id
          WHERE g.age >= #{adult_age}
        UNION ALL
         SELECT 'c' AS age,
                isconfirmed
           FROM guests g INNER JOIN
                people p ON g.person_id = p.id
          WHERE g.age < #{adult_age}
       ) AS p
-- WHERE p.isconfirmed
 GROUP BY age, isconfirmed
 ORDER BY 2 DESC,1
    SQL
    self.connection.execute(qry)
  end

  def self.count_by_allocation_sex
    max_men = Rails.application.config.reg_max_allocation_men
    max_women = Rails.application.config.reg_max_allocation_women
    core = <<-SQL
         SELECT CASE WHEN p.ismale = true THEN 'male'
                     ELSE 'female'
                END as sex,
                p.isconfirmed
           FROM allocations a INNER JOIN
                people p ON a.person_id = p.id
          WHERE 1 = 1
            AND a."option" = 1
         UNION ALL
         SELECT CASE WHEN g.ismale = true THEN 'male'
                     ELSE 'female'
                END as sex,
                p.isconfirmed
           FROM guests g INNER JOIN
                people p ON g.person_id = p.id INNER JOIN
                allocations a ON a.person_id = p.id
          WHERE 1 = 1
            AND a."option" = 1
    SQL

    qry = <<-SQL
SELECT sex,
       isconfirmed,
       count(1),
       CASE
         WHEN sex = 'male' THEN #{max_men} - count(1)
         ELSE #{max_women} - count(1)
       END as remaining
  FROM (#{core}) u
 GROUP BY sex, isconfirmed
 ORDER BY 2 DESC,1
    SQL
    self.connection.execute(qry)
  end

  def self.num_registered
    max_people = Rails.application.config.reg_max_people
    # 'A' stands for ALL
    # 'C' stands for Confirmed
    qry = <<-SQL
SELECT 'C' as concept,
       SUM(data.num + 1) as total,
       #{max_people} - SUM(data.num + 1) as remaining
  FROM (
         SELECT p.id,
                p.name,
                p.isconfirmed,
                (SELECT COUNT(1)
                   FROM guests g
                  WHERE person_id = p.id) as num
           FROM people p
          WHERE 1 = 1
            AND p.isconfirmed
       ) data
UNION ALL
SELECT 'A',
       SUM(data.num + 1),
       #{max_people} - SUM(data.num + 1)
  FROM (
         SELECT p.id,
                p.name,
                p.isconfirmed,
                (SELECT COUNT(1)
                   FROM guests g
                  WHERE person_id = p.id) as num
           FROM people p
          WHERE 1 = 1
       ) data
UNION ALL
SELECT 'N',
       SUM(data.num + 1),
       0
  FROM (
         SELECT p.id,
                p.name,
                p.isconfirmed,
                (SELECT COUNT(1)
                   FROM guests g
                  WHERE person_id = p.id) as num
           FROM people p
          WHERE 1 = 1
            AND p.iscancelled
       ) data
UNION ALL
SELECT 'P',
       SUM(data.num + 1),
       0
  FROM (
         SELECT p.id,
                p.name,
                p.isconfirmed,
                (SELECT COUNT(1)
                   FROM guests g
                  WHERE person_id = p.id) as num
           FROM people p
          WHERE 1 = 1
            AND p.ispresent
       ) data
    SQL
    self.connection.execute(qry)
  end

  def self.to_csv
    attributes = %w{id lastname name city state church total amount_paid}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |p|
        csv << attributes.map{ |attr| p.send(attr) }
      end
    end
  end

  def self.payments
    qry = <<-SQL
SELECT changed_by AS id
      ,(SELECT CONCAT(name ,' ', lastname)
          FROM people
         WHERE id = p.changed_by ) AS person
      ,(SELECT city
          FROM people
         WHERE id = p.changed_by ) AS city
      ,SUM(amount_paid) AS paid
  FROM people as p
 WHERE changed_by is not null
 GROUP BY changed_by
 ORDER BY 2
    SQL
    self.connection.execute(qry)
  end

  def self.offerings
    qry = <<-SQL
SELECT --name,
       SUM(offering) AS Offerings
  FROM people
 WHERE changed_by IS NOT NULL
   AND offering IS NOT NULL
   AND amount_paid >= offering
   AND isconfirmed
--  group by name
    SQL
    self.connection.execute(qry)
  end

  # GRAPH Reports //////////////////////////////////////////////////////////////////////////////////////////////////////
  def self.graph_by_date
    qry = <<-SQL
  SELECT date(created_at) as date,
         count(1) as count
    FROM people
GROUP BY date(created_at)
ORDER BY date(created_at)
      SQL
    self.connection.execute(qry)
  end
  def self.graph_by_dow
    qry = <<-SQL
  SELECT date('2016-07-03') + cast(EXTRACT(DOW FROM created_at) as int) as date,
         --EXTRACT(DOW FROM created_at) as date,
         count(1) as count
    FROM people
GROUP BY EXTRACT(DOW FROM created_at)
ORDER BY EXTRACT(DOW FROM created_at)
    SQL
    self.connection.execute(qry)
  end
  def self.graph_by_week
    qry = <<-SQL
  SELECT CAST(EXTRACT(WEEK FROM created_at) as int) as date,
         count(1) as count
    FROM people
GROUP BY EXTRACT(WEEK FROM created_at)
ORDER BY EXTRACT(WEEK FROM created_at)
    SQL
    self.connection.execute(qry)
  end
  def self.graph_by_country
    qry = <<-SQL
  SELECT country as cat,
         count(1) as count
    FROM people
GROUP BY country
ORDER BY country
    SQL
    self.connection.execute(qry)
  end
  def self.graph_by_city
    qry = <<-SQL
  SELECT city as cat,
         count(1) as count
    FROM people
GROUP BY city
ORDER BY city
    SQL
    self.connection.execute(qry)
  end


  private
    def init
      self.isconfirmed = false if self.isconfirmed.nil?
      self.iscancelled = false if self.iscancelled.nil?
      self.ispresent   = false if self.ispresent.nil?
      self.isnotified  = false if self.isnotified.nil?
      self.ismale      = true  if self.ismale.nil?

      self.assist_v    = false if self.assist_v.nil?
      self.assist_s    = false if self.assist_s.nil?
      self.assist_d    = false if self.assist_d.nil?
      self.assist_l    = false if self.assist_l.nil?

      self.amount_paid ||= 0
      self.age         ||= 0

      self.isadmin     = false if self.isadmin.nil? #DON'T EVER CHANGE THIS
    end

    def create_password
      if self.salt.to_s == ''
        self.salt = SecureRandom.base64(12)
      end

      set_password self.password
    end

    def normalize_all
      self.name = self.name.titleize.strip
      self.lastname = self.lastname.titleize.strip
      self.church = self.church.titleize.strip
      self.country = self.country.titleize.strip
      self.state = self.state.titleize.strip
      self.city = self.city.titleize.strip

      self.nickname = self.nickname.strip
      self.email = self.email.downcase.strip
    end

    def check_paid_amount
      self.isconfirmed = self.amount_paid >= self.total
    end
end
