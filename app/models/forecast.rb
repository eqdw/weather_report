class Forecast < ApplicationRecord

  WIND_SPEED_LOOKUP = %w[North North-East East South-East South South-West West North-West]

  def self.create_from_api_response(data)
    # translate compass degree to human direction
    direction = WIND_SPEED_LOOKUP[ (data['wind']['direction'].to_f / 45).round ]

    Forecast.create(
      valid_at: Time.at(data['dt']),
      valid_until: 30.minutes.from_now,
      zip: data['zip'],
      temp: data['main']['temp'].round,
      temp_min: data['main']['temp_min'].round,
      temp_max: data['main']['temp_max'].round,
      humidity: data['main']['humidity'],
      wind_speed: data['wind']['speed'],
      wind_direction: direction
    )
  end
end
