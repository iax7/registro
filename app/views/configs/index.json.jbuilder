json.array!(@configs) do |config|
  json.extract! config, :id, :foodcost, :allocationcost, :fooddeadline, :allocationdeadline
  json.url config_url(config, format: :json)
end
