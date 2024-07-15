require 'rails_helper'

RSpec.describe ForecastsController, type: :controller do
  describe 'GET index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'assigns @forecast and @error when zip_code is present' do
      allow(Forecast).to receive(:for_address).and_return(Forecast.new(current_temp: 72, high_temp: 82, low_temp: 62, location: 'Test City', extended_forecast: [], from_cache: false))
      get :index, params: { zip_code: '12345' }
      expect(assigns(:forecast)).to be_a(Forecast)
      expect(assigns(:error)).to be_nil
    end

    it 'assigns @error when zip_code is not present' do
      get :index, params: { zip_code: '' }
      expect(assigns(:forecast)).to be_nil
      expect(assigns(:error)).to eq('Please provide a zip code.')
    end

    it 'assigns @error when forecast is nil' do
      allow(Forecast).to receive(:for_address).and_return(nil)
      get :index, params: { zip_code: 'invalid_zip' }
      expect(assigns(:forecast)).to be_nil
      expect(assigns(:error)).to eq('Unable to retrieve weather data for the given zip code.')
    end
  end
end
