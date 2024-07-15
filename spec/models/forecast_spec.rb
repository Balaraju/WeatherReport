require 'rails_helper'

RSpec.describe Forecast, type: :model do
  describe '.for_address' do
    let(:zip_code) { '12345' }

    context 'when forecast data is cached' do
      before do
        Rails.cache.write("forecast-#{zip_code}", Forecast.new(current_temp: 70, high_temp: 80, low_temp: 60, location: 'Test City', extended_forecast: [], from_cache: true))
      end

      it 'returns cached forecast' do
        forecast = Forecast.for_address(zip_code)
        expect(forecast.current_temp).to eq(70)
        expect(forecast.from_cache).to be true
      end
    end

    context 'when forecast data is not cached' do
      before do
        allow(Forecast).to receive(:retrieve_forecast_data).and_return({ current_temp: 72, high_temp: 82, low_temp: 62, location: 'Test City', extended_forecast: [] })
        allow(Rails.cache).to receive(:write)
      end

      it 'fetches and caches forecast data' do
        forecast = Forecast.for_address(zip_code)
        expect(forecast.current_temp).to eq(70)
        expect(forecast.from_cache).to be true
      end
    end

    context 'when API request fails' do
      before do
        allow(HTTParty).to receive(:get).and_raise(HTTParty::Error, 'API error')
      end

      it 'returns nil' do
        Rails.cache.delete("forecast-#{zip_code}")
        zip_code = "Abc"
        forecast = Forecast.for_address(zip_code)
        expect(forecast).to be_nil
      end
    end
  end
end
