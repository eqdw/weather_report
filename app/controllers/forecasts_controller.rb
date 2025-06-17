class ForecastsController < ApplicationController
  # GET /forecasts or /forecasts.json
  before_action :validate_zip, only: :search

  # Page with the 'type your address in' form
  def index
    @forecasts = Forecast.all
  end

  def search
    zip = params[:forecast][:zip]
    @forecast = Forecast.unexpired.where(zip: zip).first

    cached_time = @forecast&.created_at

    @forecast ||=
      Forecast.create_from_api_response(
        OpenWeatherMapApiClient.execute(zip)
      )

    render :search, locals: { cached_time: cached_time }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_forecast
    #   @forecast = Forecast.find(params.expect(:id))
    # end

    # Only allow a list of trusted parameters through.
    def forecast_params
      params.expect(forecast: [ :zip ])
    end

  def validate_zip
    unless params[:forecast][:zip].present?
      flash[:notice] = "You must supply a zip code for the weather forecast"

      redirect_to :forecasts
    end
  end
end
