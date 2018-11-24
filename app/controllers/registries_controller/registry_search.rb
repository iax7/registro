# frozen_string_literal: true

class RegistriesController
  # Contains the custom query in which is based all filters in index view
  class RegistrySearch
    def self.main_query
      Registry.select(%(registry_id,
            users.id,
            users.lastname || ', ' || users.name AS full_name,
            users.is_admin,
            users.is_male,
            users.email,
            date_part('year', CURRENT_DATE) - date_part('year', users.dob) AS age,
            registries.amount_debt,
            registries.amount_offering,
            registries.amount_debt + registries.amount_offering AS grand_total,
            registries.amount_paid,
            registries.comments,
            registries.is_present,
            g.*))
              .joins(%(INNER JOIN
            users ON users.id = registries.user_id INNER JOIN
            (
            SELECT registry_id,
                  COUNT(1) AS num,
                  SUM(is_pregnant::int) AS pregnancy,
                  SUM(is_medicated::int) AS medicated,
                  SUM(f_v1::int) AS f_v1,
                  SUM(f_v2::int) AS f_v2,
                  SUM(f_v3::int) AS f_v3,
                  SUM(f_s1::int) AS f_s1,
                  SUM(f_s2::int) AS f_s2,
                  SUM(f_s3::int) AS f_s3,
                  SUM(f_d1::int) AS f_d1,
                  SUM(f_d2::int) AS f_d2,
                  SUM(f_d3::int) AS f_d3,
                  SUM(f_l1::int) AS f_l1,
                  SUM(f_l2::int) AS f_l2,
                  SUM(f_l3::int) AS f_l3,
                  SUM(t_v1::int) AS t_v1,
                  SUM(t_v2::int) AS t_v2,
                  SUM(t_s1::int) AS t_s1,
                  SUM(t_s2::int) AS t_s2,
                  SUM(t_d1::int) AS t_d1,
                  SUM(t_d2::int) AS t_d2,
                  SUM(t_l1::int) AS t_l1,
                  SUM(t_l2::int) AS t_l2,
                  SUM(l_v::int) AS l_v,
                  SUM(l_s::int) AS l_s,
                  SUM(l_d::int) AS l_d,
                  SUM(l_l::int) AS l_l,
                  STRING_AGG(l_room, ', ') AS l_rooms,
                  STRING_AGG('<strong>' || id || '</strong> - ' || nick || ' (' || age || ')' || room, '<br>') AS formated_ids
             FROM (SELECT *, COALESCE(' --> ' || l_room, '') AS room FROM guests ORDER BY registry_id, age DESC) guests
            GROUP BY registry_id
            ) g ON g.registry_id = registries.id))
    end
  end
end
