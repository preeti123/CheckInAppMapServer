class Checkin < ActiveRecord::Base
  self.table_name = 'checkins'

  alias_attribute :lat, :latitude
  alias_attribute :lon, :longitude

  def distance_in_miles(to_lat, to_lon)
    (self.distance_in_kilometers(to_lat, to_lon) * 0.621371).to_d.floor(2)
  end

  def distance_in_kilometers(to_lat, to_lon)
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers

    dlon_rad = (to_lon - self.lon) * rad_per_deg  # Delta, converted to rad
    dlat_rad = (to_lat - self.lat) * rad_per_deg

    lat1_rad = rad_per_deg * to_lat
    lon1_rad = rad_per_deg * to_lon

    lat2_rad = rad_per_deg * self.lat
    lon2_rad = rad_per_deg * self.lon

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math.asin(Math.sqrt(a))

    (rkm * c).to_d.floor(2) # Delta in kilometers
  end
end