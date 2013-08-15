require 'geocoder'

class Geocodes
  def search(countryname)
    r = Geocoder.search(countryname)
    r[0].nil? ?
        {:latitude => "", :longitude => "", :address => ""} :
        {:latitude => r[0].latitude, :longitude => r[0].longitude, :address => r[0].address}
  end
end