json.array!(@countries) do |country|
  json.extract! country, :id, :name, :iso
  json.url country_url(country, format: :json)
end
