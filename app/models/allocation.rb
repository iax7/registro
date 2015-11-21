class Allocation < ActiveRecord::Base
  belongs_to :person
  after_initialize :init
  before_save :check_option

  #enum option: { :none => 0, :camp => 1, :hotel => 2 }

  validates :option,
            presence: true,
            inclusion: [ 0, 1, 2 ]

  validates :n1,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }
  validates :n2,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }
  validates :n3,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }

  def total_nights
    self.n1 + self.n2 + self.n3
  end

  def total_cost
    full = Rails.application.config.reg_allocation_full_price
    half = Rails.application.config.reg_allocation_half_price
    # n3 is for free, not added in cost calculation
    sigma = 0
    sigma += self.n1 * full
    sigma += self.n2 * half
  end

  # Filters --------
  def self.has_allocation
    Allocation
        .includes(person: [:guests])
        .joins(:person)
        .where('(n1 > 0 OR n2 > 0 OR n3 > 0)
                AND option = 1')
        .order('people.lastname')
  end

  def self.has_allocation_confirmed
    Allocation.has_allocation
        .where('people.isconfirmed')
  end

  def self.available_totals
    # C -> Confirmed
    # A -> ALL
    qry = <<-SQL
SELECT 'C' as concept,
       SUM(n1) as n1,
       SUM(n2) as n2,
       SUM(n3) as n3
  FROM allocations a inner join
       people p ON a.person_id = p.id
 WHERE 1 = 1
   AND a.option = 1
   AND p.isconfirmed
UNION ALL
SELECT 'A' as concept,
       SUM(n1) as n1,
       SUM(n2) as n2,
       SUM(n3) as n3
  FROM allocations a inner join
       people p ON a.person_id = p.id
 WHERE 1 = 1
   AND a.option = 1
--   AND p.isconfirmed
    SQL
    self.connection.execute(qry)
  end

  def init
    self.option ||= 0
    self.n1   ||= 0
    self.n2   ||= 0
    self.n3   ||= 0
  end

  def check_option
    if self.option != 1
      self.n1 = 0
      self.n2 = 0
      self.n3 = 0
    end
  end

end
