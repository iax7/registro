# frozen_string_literal: true

json.extract! event, :id, :name, :f_v1, :f_v2, :f_v3, :f_s1, :f_s2, :f_s3, :f_d1, :f_d2, :f_d3, :f_l1, :f_l2, :f_l3, :t_v, :t_s, :t_d, :t_l, :l_v, :l_s, :l_d, :l_l, :created_at, :updated_at
json.url event_url(event, format: :json)
