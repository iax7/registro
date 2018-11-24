# frozen_string_literal: true

# Stores all custon queries used in html reports
module Queries
  def self.people(event)
    <<~SQL
      SELECT 'all' AS status, COUNT(1) AS total
        FROM registries r INNER JOIN
             guests g ON r.id = g.registry_id INNER JOIN
             events e ON r.event_id = e.id
       WHERE e.name = '#{event}'
      UNION ALL
      SELECT 'paid' AS status, COUNT(1) AS total
        FROM registries r INNER JOIN
             guests g ON r.id = g.registry_id INNER JOIN
             events e ON r.event_id = e.id
       WHERE e.name = '#{event}'
         AND (r.amount_debt + r.amount_offering ) <= r.amount_paid
    SQL
  end

  def self.offerings(event)
    <<~SQL
      SELECT 'all' AS status, COALESCE(SUM(r.amount_offering), 0) AS total
        FROM registries r INNER JOIN
             events e ON r.event_id = e.id
       WHERE e.name = '#{event}'
      UNION ALL
      SELECT 'paid' AS status, COALESCE(SUM(r.amount_offering), 0) AS total
        FROM registries r INNER JOIN
             events e ON r.event_id = e.id
       WHERE e.name = '#{event}'
         AND (r.amount_debt + r.amount_offering ) <= r.amount_paid
    SQL
  end

  def self.services(event)
    <<~SQL
      SELECT 'all' AS status,
             sum(g.f_v1::int) AS f_v1, sum(g.f_v2::int) AS f_v2, sum(g.f_v3::int) AS f_v3,
             sum(g.f_s1::int) AS f_s1, sum(g.f_s2::int) AS f_s2, sum(g.f_s3::int) AS f_s3,
             sum(g.f_d1::int) AS f_d1, sum(g.f_d2::int) AS f_d2, sum(g.f_d3::int) AS f_d3,
             sum(g.f_l1::int) AS f_l1, sum(g.f_l2::int) AS f_l2, sum(g.f_l3::int) AS f_l3,
             sum(g.t_v1::int) AS t_v1, sum(g.t_v2::int) AS t_v2,
             sum(g.t_s1::int) AS t_s1, sum(g.t_s2::int) AS t_s2,
             sum(g.t_d1::int) AS t_d1, sum(g.t_d2::int) AS t_d2,
             sum(g.t_l1::int) AS t_l1, sum(g.t_l2::int) AS t_l2,
             sum(g.l_v::int)  AS l_v,
             sum(g.l_s::int)  AS l_s,
             sum(g.l_d::int)  AS l_d,
             sum(g.l_l::int)  AS l_l
        FROM registries r INNER JOIN
             guests g ON r.id = g.registry_id INNER JOIN
             events e ON r.event_id = e.id
       WHERE e.name = '#{event}'
      UNION ALL
      SELECT 'paid' AS status,
             coalesce(sum(g.f_v1::int), 0) AS f_v1, coalesce(sum(g.f_v2::int), 0) AS f_v2, coalesce(sum(g.f_v3::int), 0) AS f_v3,
             coalesce(sum(g.f_s1::int), 0) AS f_s1, coalesce(sum(g.f_s2::int), 0) AS f_s2, coalesce(sum(g.f_s3::int), 0) AS f_s3,
             coalesce(sum(g.f_d1::int), 0) AS f_d1, coalesce(sum(g.f_d2::int), 0) AS f_d2, coalesce(sum(g.f_d3::int), 0) AS f_d3,
             coalesce(sum(g.f_l1::int), 0) AS f_l1, coalesce(sum(g.f_l2::int), 0) AS f_l2, coalesce(sum(g.f_l3::int), 0) AS f_l3,
             coalesce(sum(g.t_v1::int), 0) AS t_v1, coalesce(sum(g.t_v2::int), 0) AS t_v2,
             coalesce(sum(g.t_s1::int), 0) AS t_s1, coalesce(sum(g.t_s2::int), 0) AS t_s2,
             coalesce(sum(g.t_d1::int), 0) AS t_d1, coalesce(sum(g.t_d2::int), 0) AS t_d2,
             coalesce(sum(g.t_l1::int), 0) AS t_l1, coalesce(sum(g.t_l2::int), 0) AS t_l2,
             coalesce(sum(g.l_v::int ), 0) AS l_v,
             coalesce(sum(g.l_s::int ), 0) AS l_s,
             coalesce(sum(g.l_d::int ), 0) AS l_d,
             coalesce(sum(g.l_l::int ), 0) AS l_l
        FROM registries r INNER JOIN
             guests g ON r.id = g.registry_id INNER JOIN
             events e ON r.event_id = e.id
       WHERE e.name = '#{event}'
         AND (r.amount_debt + r.amount_offering ) <= r.amount_paid
    SQL
  end

  def self.food_by_age_paid_status(event)
    <<~SQL
      SELECT f.is_paid,
             f.age AS status,
             sum(f.f_v1) AS f_v1, sum(f.f_v2) AS f_v2, sum(f.f_v3) AS f_v3,
             sum(f.f_s1) AS f_s1, sum(f.f_s2) AS f_s2, sum(f.f_s3) AS f_s3,
             sum(f.f_d1) AS f_d1, sum(f.f_d2) AS f_d2, sum(f.f_d3) AS f_d3,
             sum(f.f_l1) AS f_l1, sum(f.f_l2) AS f_l2, sum(f.f_l3) AS f_l3
        FROM (
              SELECT CASE WHEN (g.age >= (SELECT settings ->> 'adult_age' FROM events)::int)
                          THEN 'adult' ELSE 'child' END AS age,
                     (r.amount_debt + r.amount_offering ) <= r.amount_paid AS is_paid,
                     g.f_v1::int, g.f_v2::int, g.f_v3::int,
                     g.f_s1::int, g.f_s2::int, g.f_s3::int,
                     g.f_d1::int, g.f_d2::int, g.f_d3::int,
                     g.f_l1::int, g.f_l2::int, g.f_l3::int
                FROM registries r INNER JOIN
                     guests g ON r.id = g.registry_id INNER JOIN
                     events e ON r.event_id = e.id
               WHERE e.name = '#{event}') f
      GROUP BY 1,2
    SQL
  end

  def self.food_used_by_age(event)
    <<~SQL
      SELECT f.age AS status,
             sum(f.fu_v1) AS f_v1, sum(f.fu_v2) AS f_v2, sum(f.fu_v3) AS f_v3,
             sum(f.fu_s1) AS f_s1, sum(f.fu_s2) AS f_s2, sum(f.fu_s3) AS f_s3,
             sum(f.fu_d1) AS f_d1, sum(f.fu_d2) AS f_d2, sum(f.fu_d3) AS f_d3,
             sum(f.fu_l1) AS f_l1, sum(f.fu_l2) AS f_l2, sum(f.fu_l3) AS f_l3
        FROM (
      SELECT CASE WHEN (g.age >= (SELECT settings ->> 'adult_age' FROM events)::int)
                          THEN 'adult' ELSE 'child' END AS age,
                     g.fu_v1, g.fu_v2, g.fu_v3,
                     g.fu_s1, g.fu_s2, g.fu_s3,
                     g.fu_d1, g.fu_d2, g.fu_d3,
                     g.fu_l1, g.fu_l2, g.fu_l3
                FROM registries r INNER JOIN
                     guests g ON r.id = g.registry_id INNER JOIN
                     events e ON r.event_id = e.id
               WHERE e.name = '#{event}') f
      GROUP BY 1;
    SQL
  end

  def self.lodging_by_age_sex(event)
    <<~SQL
      SELECT 'all' AS status,
             sum(CASE WHEN (l.is_adult and l.is_male)
                      THEN 1 ELSE 0 END) AS m,
             sum(CASE WHEN (l.is_adult and l.is_male = false)
                      THEN 1 ELSE 0 END) AS f,
             sum(CASE WHEN (l.is_adult = false and l.is_male)
                      THEN 1 ELSE 0 END) AS cm,
             sum(CASE WHEN (l.is_adult = false and l.is_male = false)
                      THEN 1 ELSE 0 END) AS cf,
             count(1) AS sum
        FROM (
              SELECT (g.age >= (SELECT settings ->> 'adult_age' FROM events)::int) AS is_adult,
                     (r.amount_debt + r.amount_offering ) <= r.amount_paid AS is_paid,
                     g.is_male, g.l_v, g.l_s, g.l_d, g.l_l
                FROM registries r INNER JOIN
                     guests g ON r.id = g.registry_id INNER JOIN
                     events e ON r.event_id = e.id
               WHERE e.name = '#{event}'
              ) l
      WHERE l.l_v = true
      UNION ALL
      SELECT 'paid' AS status,
             COALESCE(sum(CASE WHEN (l.is_adult and l.is_male)
                               THEN 1 ELSE 0 END), 0) AS m,
             COALESCE(sum(CASE WHEN (l.is_adult and l.is_male = false)
                               THEN 1 ELSE 0 END), 0) AS f,
             COALESCE(sum(CASE WHEN (l.is_adult = false and l.is_male)
                               THEN 1 ELSE 0 END), 0) AS cm,
             COALESCE(sum(CASE WHEN (l.is_adult = false and l.is_male = false)
                               THEN 1 ELSE 0 END), 0) AS cf,
             COUNT(1) AS sum
        FROM (
              SELECT (g.age >= (SELECT settings ->> 'adult_age' FROM events)::int) AS is_adult,
                     (r.amount_debt + r.amount_offering ) <= r.amount_paid AS is_paid,
                     g.is_male, g.l_v, g.l_s, g.l_d, g.l_l
                FROM registries r INNER JOIN
                     guests g ON r.id = g.registry_id INNER JOIN
                     events e ON r.event_id = e.id
               WHERE e.name = '#{event}'
              ) l
      WHERE l.l_v = true
        AND l.is_paid
    SQL
  end

  def self.pay_collectors(event)
    <<~SQL
      SELECT u.id,
             CONCAT(u.name ,' ', u.lastname) AS name,
             CONCAT(u.city, ', ', u.state) AS location,
             SUM(r.amount_paid) AS amount
        FROM registries r INNER JOIN
             users u ON r.paid_by = u.id INNER JOIN
             events e ON r.event_id = e.id
       WHERE e.name = '#{event}'
      GROUP BY 1, 2, 3
      ORDER BY 1
    SQL
  end

  def self.list_lodging(event)
    <<~SQL
      SELECT *
        FROM (
              SELECT r.id,
                     g.id AS id2,
                     g.lastname || ', ' || g.name AS name,
                     CASE WHEN g.is_male = true THEN 'Hombre'
                          ELSE 'Mujer' END AS sex,
                     g.relation AS relation,
                     g.age,
                     CONCAT(u.city, ', ', u.state) AS location
                FROM registries r INNER JOIN
                     guests g ON r.id = g.registry_id INNER JOIN
                     events e ON r.event_id = e.id INNER JOIN
                     users u ON r.user_id = u.id
               WHERE e.name = '#{event}'
                 AND g.relation = 0
                 AND g.l_v OR g.l_s OR g.l_d OR g.l_l
              UNION ALL
              SELECT r.id,
                     g.id AS id2,
                     '  - ' || g.lastname || ', ' || g.name AS name,
                     CASE WHEN g.is_male = true THEN 'Hombre'
                          ELSE 'Mujer' END AS sex,
                     g.relation AS relation,
                     g.age,
                     '' AS location
                FROM registries r INNER JOIN
                     guests g ON r.id = g.registry_id INNER JOIN
                     events e ON r.event_id = e.id
               WHERE e.name = '#{event}'
                 AND g.relation <> 0
                 AND g.l_v OR g.l_s OR g.l_d OR g.l_l
             ) l
      ORDER BY l.id, l.relation, l.age DESC
    SQL
  end
end
