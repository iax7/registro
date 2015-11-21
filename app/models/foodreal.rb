class Foodreal < ActiveRecord::Base
  belongs_to :person
  after_initialize :init

  validates :v1 , :v2 , :v3 , :s1 , :s2 , :s3 , :d1 , :d2 , :d3 , :l1 , :l2 , :l3 ,
            :v1c, :v2c, :v3c, :s1c, :s2c, :s3c, :d1c, :d2c, :d3c, :l1c, :l2c, :l3c,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }

  def self.sum_for(day_field)
    unless self.column_names.include? day_field
      raise 'Column does not exists'
    end

    qry = <<-SQL
SELECT SUM(#{day_field} + #{day_field}c) AS currently
  FROM foodreals f
    SQL
    self.connection.execute(qry).first
  end

  def self.sum_all
    qry = <<-SQL
SELECT sum(v1) AS v1,
       sum(v2) AS v2,
       sum(v3) AS v3,
       sum(s1) AS s1,
       sum(s2) AS s2,
       sum(s3) AS s3,
       sum(d1) AS d1,
       sum(d2) AS d2,
       sum(d3) AS d3,
       sum(l1) AS l1,
       sum(l2) AS l2,
       sum(l3) AS l3,
       sum(v1c) AS v1c,
       sum(v2c) AS v2c,
       sum(v3c) AS v3c,
       sum(s1c) AS s1c,
       sum(s2c) AS s2c,
       sum(s3c) AS s3c,
       sum(d1c) AS d1c,
       sum(d2c) AS d2c,
       sum(d3c) AS d3c,
       sum(l1c) AS l1c,
       sum(l2c) AS l2c,
       sum(l3c) AS l3c
  FROM foodreals
    SQL
    self.find_by_sql(qry)
  end

  def init
    self.v1 ||= 0
    self.v2 ||= 0
    self.v3 ||= 0
    self.s1 ||= 0
    self.s2 ||= 0
    self.s3 ||= 0
    self.d1 ||= 0
    self.d2 ||= 0
    self.d3 ||= 0
    self.l1 ||= 0
    self.l2 ||= 0
    self.l3 ||= 0

    self.v1c ||= 0
    self.v2c ||= 0
    self.v3c ||= 0
    self.s1c ||= 0
    self.s2c ||= 0
    self.s3c ||= 0
    self.d1c ||= 0
    self.d2c ||= 0
    self.d3c ||= 0
    self.l1c ||= 0
    self.l2c ||= 0
    self.l3c ||= 0
  end
end
