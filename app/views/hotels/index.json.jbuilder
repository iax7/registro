json.array!(@hotels) do |hotel|
  json.extract! hotel, :id, :name, :address, :phone, :email, :cost, :url, :gmaps, :comments, :has_discount
  json.url hotel_url(hotel, format: :json)
end
