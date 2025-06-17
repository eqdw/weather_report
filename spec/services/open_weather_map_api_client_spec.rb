require 'rails_helper'

RSpec.describe OpenWeatherMapApiClient do
  let(:example_api_response) do
    { "cod" => "200",
     "message" => 0,
     "cnt" => 40,
     "list" =>
       [ { "dt" => 1750204800,
         "main" => { "temp" => 93.69, "feels_like" => 103.48, "temp_min" => 91.94, "temp_max" => 93.69, "pressure" => 1009, "sea_level" => 1009, "grnd_level" => 986, "humidity" => 52, "temp_kf" => 0.97 },
         "weather" => [ { "id" => 802, "main" => "Clouds", "description" => "scattered clouds", "icon" => "03d" } ],
         "clouds" => { "all" => 40 },
         "wind" => { "speed" => 16.87, "deg" => 155, "gust" => 21.65 },
         "visibility" => 10000,
         "pop" => 0,
         "sys" => { "pod" => "d" },
         "dt_txt" => "2025-06-18 00:00:00" },
        { "dt" => 1750215600,
         "main" => { "temp" => 90.75, "feels_like" => 99.18, "temp_min" => 84.87, "temp_max" => 90.75, "pressure" => 1009, "sea_level" => 1009, "grnd_level" => 988, "humidity" => 56, "temp_kf" => 3.27 },
         "weather" => [ { "id" => 802, "main" => "Clouds", "description" => "scattered clouds", "icon" => "03n" } ],
         "clouds" => { "all" => 27 },
         "wind" => { "speed" => 16.22, "deg" => 167, "gust" => 30.47 },
         "visibility" => 10000,
         "pop" => 0,
         "sys" => { "pod" => "n" },
         "dt_txt" => "2025-06-18 03:00:00" }
       ],
     "city" => { "id" => 0, "name" => "Austin", "coord" => { "lat" => 30.2638, "lon" => -97.7166 }, "country" => "US", "population" => 0, "timezone" => -18000, "sunrise" => 1750159743, "sunset" => 1750210482 }
    }
  end

  let(:example_returned_response) do
    { "dt" => 1750204800,
     "main" => { "temp" => 93.69, "feels_like" => 103.48, "temp_min" => 91.94, "temp_max" => 93.69, "pressure" => 1009, "sea_level" => 1009, "grnd_level" => 986, "humidity" => 52, "temp_kf" => 0.97 },
     "weather" => [ { "id" => 802, "main" => "Clouds", "description" => "scattered clouds", "icon" => "03d" } ],
     "clouds" => { "all" => 40 },
     "wind" => { "speed" => 16.87, "deg" => 155, "gust" => 21.65 },
     "visibility" => 10000,
     "pop" => 0,
     "sys" => { "pod" => "d" },
     "dt_txt" => "2025-06-18 00:00:00",
     "zip" => 78702 }.deep_symbolize_keys!
  end

  context '#execute' do
    before do
      allow(HTTParty).to receive(:get).and_return(example_api_response)
    end

    context 'no location given' do
      it 'returns nil and does not hit the api' do
        client = OpenWeatherMapApiClient.new(nil)

        expect(client.execute).to be_nil

        expect(HTTParty).not_to have_received(:get)
      end
    end

    context 'failure response received' do
      before do
        error_code_response = example_api_response.merge({ "cod" => 404 })
        allow(HTTParty).to receive(:get).and_return(error_code_response)
      end

      it 'returns nil to signal no result' do
        client = OpenWeatherMapApiClient.new(78702)

        expect(client.execute).to be_nil

        expect(HTTParty).to have_received(:get)
      end
    end

    context 'success' do
      it 'returns the first weather forecast result for that location' do
        client = OpenWeatherMapApiClient.new(78702)
        result = client.execute

        expect(result).to eq(example_returned_response)
      end
    end
  end
end
