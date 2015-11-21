json.array!(@churches) do |church|
  json.extract! church, :id, :name
  json.url church_url(church, format: :json)
end
