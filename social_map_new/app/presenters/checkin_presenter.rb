class CheckinPresenter

  def initialize(checkin, lat = nil, lon = nil, options = {})
    @checkin = checkin
    @lat = lat
    @lon = lon
    @detailed = options[:detailed]
    @lite = options[:lite]
  end

  def to_hash
    h = {}
    h[:id] = @checkin.id
    h[:lat] = @checkin.lat
    h[:lon] = @checkin.lon
    h[:text] = @checkin.text
    h[:category] = @checkin.category
    h[:distance_in_miles] = @checkin.distance_in_miles(@lat, @lon) if @lat.present? && @lon.present?
    h[:distance_in_kilometers] = @checkin.distance_in_kilometers(@lat, @lon) if @lat.present? && @lon.present?

    return h
  end
end
