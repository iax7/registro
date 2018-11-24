# frozen_string_literal: true

json.extract! guest, :id, :registry_id, :name, :lastname, :nick, :is_male, :age, :relation, :is_pregnant, :is_medicated, :f_v1, :f_v2, :f_v3, :f_s1, :f_s2, :f_s3, :f_d1, :f_d2, :f_d3, :f_l1, :f_l2, :f_l3, :t_v1, :t_v2, :t_s1, :t_s2, :t_d1, :t_d2, :t_l1, :t_l2, :l_v, :l_s, :l_d, :l_l, :l_room, :created_at, :updated_at
json.url guest_url(guest, format: :json)
