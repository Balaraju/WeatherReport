# app/models/forecast.rb
class Forecast
  CACHE_EXPIRATION = 30.minutes
	#TODO - We have to put this key into env.
  API_KEY = '6ecdfa69dc204bfd86103050241407'

  attr_reader :current_temp, :high_temp, :low_temp, :location, :extended_forecast
  attr_accessor :from_cache

  def initialize(attributes)
    @current_temp = attributes[:current_temp]
    @high_temp = attributes[:high_temp]
    @low_temp = attributes[:low_temp]
    @location = attributes[:location]
    @extended_forecast = attributes[:extended_forecast]
    @from_cache = attributes[:from_cache]
  end

  def self.for_address(zip_code)
    cached_forecast = Rails.cache.read("forecast-#{zip_code}")

    if cached_forecast
      cached_forecast.from_cache = true  # Set from_cache to true when fetched from cache
      cached_forecast
    else
      forecast_data = retrieve_forecast_data(zip_code)
      if forecast_data
        forecast = new(
          current_temp: forecast_data[:current_temp],
          high_temp: forecast_data[:high_temp],
          low_temp: forecast_data[:low_temp],
          location: forecast_data[:location],
          extended_forecast: forecast_data[:extended_forecast],
          from_cache: false  # Set from_cache to false when fetched from API
        )
        Rails.cache.write("forecast-#{zip_code}", forecast, expires_in: CACHE_EXPIRATION)
        forecast
      else
        nil
      end
    end
  end

  private

  def self.retrieve_forecast_data(zip_code)
    url = "http://api.weatherapi.com/v1/forecast.json?key=#{API_KEY}&q=#{zip_code}&days=3"
    begin
      response = HTTParty.get(url)
      if response.success?
        current = response.parsed_response['current']
        forecast = response.parsed_response['forecast']['forecastday']
        location = response.parsed_response['location']
        extended_forecast = forecast[1..].map do |day|
          {
            date: day['date'],
            max_temp: day['day']['maxtemp_f'],
            min_temp: day['day']['mintemp_f']
          }
        end

        {
          current_temp: current['temp_f'],
          high_temp: forecast[0]['day']['maxtemp_f'],
          low_temp: forecast[0]['day']['mintemp_f'],
          extended_forecast: extended_forecast,
          location: "#{location['name']}, #{location['region']}, #{location['country']}"
        }
      else
        Rails.logger.error "HTTParty request failed: #{response.code} - #{response.message}"
        nil
      end
    rescue HTTParty::Error => e
      Rails.logger.error "HTTParty error: #{e.message}"
      nil
    rescue StandardError => e
      Rails.logger.error "An error occurred: #{e.message}"
      nil
    end
  end
end
