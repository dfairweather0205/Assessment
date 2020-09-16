# TODO create base class and extends JSONAPI::ResourceController then have all my classes extend base class
# should not inherit third party resource directly, it makes it hard to decoupe code from external resources
# when changing them

class TrailsController < JSONAPI::ResourceController
  skip_before_action :verify_authenticity_token

  def search
    render json: {status: :error, message: 'lat and lon must be present'} and return if params[:lat].blank? || params[:lon].blank?
    
    lat = params[:lat]
    lon = params[:lon]
    radius = params[:radius]

    fetched_cache = Trail.where({latitude: params[:lat], longitude: params[:lon]}).first
    # TODO FIX THIS HACK
    render json: {date_cached: fetched_cache.created_at, results: JSON.parse(fetched_cache.cache.gsub('=>', ':')) } and return if fetched_cache.present?

    weather = Weather::WeatherApi.instance.get_by_lat_lon(lat, lon)
    hiking = Hiking::HikingApi.instance.get_by_lat_lon(lat, lon, radius)

    description = weather["weather"][0]["description"] if weather["weather"].present?
    description = "#{weather["clouds"]["all"]}% Cloudy" unless weather["weather"].present?

    weather_details = {
      high: weather["main"]["temp_max"],
      low: weather["main"]["temp_min"],
      feels_like: weather["main"]["feels_like"],
      description: description,
      location: "#{weather["name"]}, #{weather["sys"]["country"]}"
    }

    result = {
      weather: weather_details,
      trails: hiking["trails"]
    }

    saved = Trail.create!({latitude: lat, longitude: lon, radius: radius, cache: result.as_json })
    render json: result

  end
  
end
