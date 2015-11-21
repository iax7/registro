class Transport < ActiveRecord::Base
  belongs_to :person
  after_initialize :init

  validates :v1, :v2, :s1, :s2, :d1, :d2, :l1, :l2,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }

  def total_trips
    self.v1 +
    self.v2 +
    self.s1 +
    self.s2 +
    self.d1 +
    self.d2 +
    self.l1 +
    self.l2
  end

  def total_cost
    full = Rails.application.config.reg_transport_full_price
    self.total_trips * full
  end

  # Filters --------
  def self.has_transport
    Transport
        .includes(:person)
        .joins(:person)
        .where('(v1 > 0 OR v2 > 0 OR
                 s1 > 0 OR s2 > 0 OR
                 d1 > 0 OR d2 > 0 OR
                 l1 > 0 OR l2 > 0)')
        .order('people.lastname')
  end

  def self.available_totals
    # C -> Confirmed
    # A -> ALL
    qry = <<-SQL
SELECT 'C' as concept,
       sum(v1) AS v1,
       sum(v2) AS v2,
       sum(s1) AS s1,
       sum(s2) AS s2,
       sum(d1) AS d1,
       sum(d2) AS d2,
       sum(l1) AS l1,
       sum(l2) AS l2
  FROM transports t inner join
       people p on t.person_id = p.id
 WHERE p.isconfirmed
UNION ALL
SELECT 'A' as concept,
       sum(v1) AS v1,
       sum(v2) AS v2,
       sum(s1) AS s1,
       sum(s2) AS s2,
       sum(d1) AS d1,
       sum(d2) AS d2,
       sum(l1) AS l1,
       sum(l2) AS l2
  FROM transports t inner join
       people p on t.person_id = p.id
    SQL
    self.connection.execute(qry)
  end

  def init
    self.v1 ||= 0
    self.v2 ||= 0
    self.s1 ||= 0
    self.s2 ||= 0
    self.d1 ||= 0
    self.d2 ||= 0
    self.l1 ||= 0
    self.l2 ||= 0
  end
end
