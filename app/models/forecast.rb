class Forecast < ApplicationRecord

  WIND_SPEED_LOOKUP = %w[North North-East East South-East South South-West West North-West]

  scope :unexpired, -> { where('valid_until >= ?', Time.now) }

  def self.create_from_api_response(data)
    return nil if data.nil? # do not create a forecast if we failed to get forecast data

    Forecast.create(
      valid_at: Time.at(data[:dt]),
      valid_until: 30.minutes.from_now,
      zip: data[:zip],
      temp: data[:main][:temp].round,
      temp_min: data[:main][:temp_min].round,
      temp_max: data[:main][:temp_max].round,
      humidity: data[:main][:humidity],
      wind_speed: data[:wind][:speed].round,
      wind_direction: human_readable_wind_direction(data[:wind][:direction])
    )
  end

  def self.human_readable_wind_direction(direction)
    WIND_SPEED_LOOKUP[(direction.to_f / 45).round]
  end
end
