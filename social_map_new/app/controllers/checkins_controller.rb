class CheckinsController < ApplicationController
  def index
    lat = params[:lat]
    lon = params[:lon]
    dist = params[:dist]
    min_lat = params[:min_lat]
    min_lon = params[:min_lon]
    max_lat = params[:max_lat]
    max_lon = params[:max_lon]

    category = params[:category]
    data =  if dist.present?
              based_on_lat_lon_dist(lat, lon, dist, category)
            else
              based_on_lat_lon_range(min_lat, min_lon, max_lat, max_lon, category)
            end
    render_response(:data => data, :root => 'social_map')
  end

  def create
    lat = params[:lat].to_d
    lon = params[:lon].to_d
    category = params[:category]
    text = params[:text]
    Rails.logger.info("[checkins.create] parameters: lat: #{lat}, lon: #{lon}, category:#{category}, text:#{text}")
    unless lat.present? && lon.present?
      render_error_response(:status => 400, :message => "lat and lon must be present")
	  return
    end

    checkin = ::Checkin.new
    checkin.lat = lat
    checkin.lon = lon
    checkin.text = text
    checkin.category = category if category.present?

    checkin.save
    checkin.reload
    data = CheckinPresenter.new(checkin)

    render_response(:data => data, :root => 'social_map')
  end

  private

  def based_on_lat_lon_range(min_lat, min_lon, max_lat, max_lon, category)
    Rails.logger.info("[checkins.index] parameters: min_lat: #{min_lat}, min_lon: #{min_lon}, max_lat: #{max_lat}, max_lon: #{max_lon}, category:#{category}")
    unless min_lat.present? && min_lon.present? && max_lat.present? && max_lon.present?
      render_error_response(:status => 400, :message => "min_lat, min_lon, max_lat, max_lon must be present")
	  return
    end

    min_lat = min_lat.to_d
    min_lon = min_lon.to_d
    max_lat = max_lat.to_d
    max_lon = max_lon.to_d

    sql_string =
      "SELECT *
      FROM checkins
      WHERE
        longitude BETWEEN ? AND ?
        AND latitude BETWEEN ? AND ?"

    if category.present?
      sql_string += " AND category = ?"
      checkins = Checkin.find_by_sql([sql_string, min_lon, max_lon, min_lat, max_lat, category])
    else
      checkins = Checkin.find_by_sql([sql_string, min_lon, max_lon, min_lat, max_lat])
    end

    data = checkins.collect do |checkin|
      CheckinPresenter.new(checkin)
    end
    data
  end

  def based_on_lat_lon_dist(lat, lon, dist, category)
    Rails.logger.info("[checkins.index] parameters: lat: #{lat}, lon: #{lon}, dist:#{dist}, category:#{category}")
    unless lat.present? && lon.present? && dist.present?
      render_error_response(:status => 400, :message => "lat, lon, and dist must be present")
	  return
    end

	  lat = lat.to_d
	  lon = lon.to_d
	  dist = dist.to_d

    min_lon = lon - dist / (Math.cos(deg2rad(lat)) * 69).abs;
    max_lon = lon + dist / (Math.cos(deg2rad(lat)) * 69).abs;
    min_lat = lat - (dist / 69.0)
    max_lat = lat + (dist / 69.0)

    sql_string =
      "SELECT *
      FROM checkins
      WHERE
        longitude BETWEEN ? AND ?
        AND latitude BETWEEN ? AND ?
        AND 3956.0 * 2 * asin(sqrt(power(sin((? - latitude) * pi()/180.0 / 2.0), 2.0) + cos(? * pi()/180.0) * cos(latitude * pi()/180.0) * power(sin((? - longitude) * pi()/180.0/2.0), 2.0 ))) < ?"

    if category.present?
      sql_string += " AND category = ?"
      checkins = Checkin.find_by_sql([sql_string, min_lon, max_lon, min_lat, max_lat, lat, lat, lon, dist, category])
    else
      checkins = Checkin.find_by_sql([sql_string, min_lon, max_lon, min_lat, max_lat, lat, lat, lon, dist])
    end

    data = checkins.collect do |checkin|
      CheckinPresenter.new(checkin, lat, lon)
    end
    data
  end

  def deg2rad(deg)
    return deg / 180.0 * Math::PI
  end

  def render_response(options = {})
    response = ResponsePresenter.new(options)
    render(response_format => response, :status => 200)
  end

  def render_error_response(options = {})
    http_code = options[:status]
    errors = options[:errors].present? ? options[:errors] : [{:code => "UNKNOWN_ERROR", :message => "An error has occurred."}]

    error_response = ErrorResponsePresenter.new(http_code, errors)
    Rails.logger.error(error_response.to_s)

    render(response_format => error_response, :status => http_code)
  end

  def response_format; :json; end
end
