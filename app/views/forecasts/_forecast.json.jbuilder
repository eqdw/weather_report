json.extract! forecast, :id, :data, :valid_until, :zip, :created_at, :updated_at
json.url forecast_url(forecast, format: :json)
