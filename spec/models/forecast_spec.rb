require 'rails_helper'

RSpec.describe Forecast, type: :model do
  describe '.create_from_api_response' do
    let(:example_api_response) do
      {
        dt: 1750204800,
        main: {temp: 94.21, feels_like: 104.04, temp_min: 92.03, temp_max: 94.21, pressure: 1009, sea_level: 1009, grnd_level: 986, humidity: 51, temp_kf: 1.21},
        weather: [{id: 802, main: "Clouds", description: "scattered clouds", icon: "03d"}],
        clouds: {all: 40},
        wind: {speed: 16.87, deg: 155, gust: 21.65},
        visibility: 10000,
        pop: 0,
        sys: {pod: "d"},
        dt_txt: "2025-06-18 00:00:00",
        zip: 78702
      }
    end

    context 'nil input' do
      it 'does not create a new Forecast object' do
        expect {
          Forecast.create_from_api_response(nil)
        }.not_to change(Forecast, :count)
      end
    end

    context 'valid input' do
      it 'creates a new forecast object' do
        Timecop.freeze(Time.utc(2025, 05, 05)) do
          expect(Forecast.count).to be(0)

          result = Forecast.create_from_api_response(example_api_response)

          expect(Forecast.count).to be(1)

          expect(result.valid_at).to eq(Time.at(1750204800))
          expect(result.valid_until).to eq(30.minutes.from_now)
          expect(result.zip).to eq('78702')
          expect(result.temp).to eq('94')
          expect(result.temp_min).to eq('92')
          expect(result.temp_max).to eq('94')
          expect(result.humidity).to eq('51')
          expect(result.wind_speed).to eq('17')
          expect(result.wind_direction).to eq('South-East')
        end
      end
    end

  end

  describe '.human_readable_wind_direction' do
    context 'reasonable inputs' do
      it 'converts a compass reading into the nearest 8-way direction name' do
        expect(described_class.human_readable_wind_direction(10)).to eq('North')
        expect(described_class.human_readable_wind_direction(39)).to eq('North-East')
        expect(described_class.human_readable_wind_direction(94)).to eq('East')
        expect(described_class.human_readable_wind_direction(133)).to eq('South-East')
        expect(described_class.human_readable_wind_direction(200)).to eq('South')
        expect(described_class.human_readable_wind_direction(205)).to eq('South-West')
        expect(described_class.human_readable_wind_direction(269)).to eq('West')
        expect(described_class.human_readable_wind_direction(317)).to eq('North-West')
      end
    end

    context 'unreasonable inputs' do
      it 'handles inputs outside [0, 360) reasonably' do
        north = 0 + (360 * 2)
        east = 90 - (360 * 2)
        south = 180 + (360 * 5)
        west = 270 - (360 * 3)

        expect(described_class.human_readable_wind_direction(north)).to eq('North')
        expect(described_class.human_readable_wind_direction(east)).to eq('East')
        expect(described_class.human_readable_wind_direction(south)).to eq('South')
        expect(described_class.human_readable_wind_direction(west)).to eq('West')
      end
    end
  end
end
