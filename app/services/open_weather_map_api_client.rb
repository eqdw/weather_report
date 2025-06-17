class OpenWeatherMapApiClient
  attr_reader :url, :zip

  def self.execute(*args)
    new(*args).execute
  end

  def initialize(zip)
    @zip = zip
    @url = "http://api.openweathermap.org/data/2.5/forecast?zip=#{zip}&units=imperial&appid=#{ENV['WEATHER_API_KEY']}"
  end

  # for now, just get the immediate forecast
  def execute
    response = HTTParty.get(url)

    if response['cod'] == "200" # success
      # have to make sure downstream knows where this is a forecast for
      data = response['list'].first
      data[:zip] = zip
      data
    else # failure, just return nil
      nil
    end
  end
end