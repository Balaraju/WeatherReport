# app/controllers/forecasts_controller.rb
class ForecastsController < ApplicationController
  rescue_from StandardError, with: :handle_error

  def index
    @forecast = nil
    @error = nil

    if params[:zip_code].present?
      @forecast = Forecast.for_address(params[:zip_code])
      @error = "Unable to retrieve weather data for the given zip code." if @forecast.nil?
    else
      @error = "Please provide a zip code."
    end
  end

  private

  def handle_error(exception)
    @error = "An error occurred: #{exception.message}"
    Rails.logger.error("Exception in ForecastsController: #{exception.message}")
    @forecast = nil
    render :index
  end
end
