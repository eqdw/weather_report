class Forecast < ApplicationRecord

  # Note: Semantically this would make more sense
  # as a hashmap with integer value keys, but I got
  # a syntax error when I tried to do that explicitly,
  # and I didn't want to spend time figuring that out
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
      wind_direction: human_readable_wind_direction(data[:wind][:deg])
    )
  end

  def self.human_readable_wind_direction(direction)
    # Normalize direction, in case somebody is giving us inputs out of bounds
    direction = direction % 360

    WIND_SPEED_LOOKUP[(direction.to_f / 45).round]
  end
end
