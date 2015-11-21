json.array!(@states) do |state|
  json.extract! state, :id, :key, :name, :short
  json.url state_url(state, format: :json)
end
