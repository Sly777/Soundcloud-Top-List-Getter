require './files_creation'

class Scfunctions
  def initialize(scClient)
    @scClient = scClient
    @Countries = {}
  end

  def getUserCountry(userid)
    user = @scClient.get('/users/' + userid.to_s)
    user.country
  end

  def getTrackUser(trackid)
    track = @scClient.get("/tracks/" + trackid.to_s)
    track.user.id
  end

  def increaseCountryCount(countryname)
    if !countryname.nil? then
      if (@Countries.has_key?(countryname)) then
        @Countries[countryname]+= 1
      else
        @Countries[countryname]= 1
      end
    end
  end

  def getSoundCategories(categoryName = nil)
    (categoryName.nil? ? $client.get('/explore/sounds/category', :limit => '10') : $client.get('/explore/sounds/category/' + categoryName.downcase, :limit => '10'))
  end

  def getCountries
    @Countries
  end

  def render(categoryName = nil)
    expCategory = getSoundCategories(categoryName)

    expCategory.collection.each do |category|
      category.tracks.each do |track|
        increaseCountryCount(getUserCountry(getTrackUser(track.id)))
      end

      sortedCountries = Hash[getCountries.sort_by{ |k, v| -v }]

      tmpText = "Top " + sortedCountries.first(10).length.to_s + " Countries on "+category.name+" Category\n"
      tmpText += "-----------------------------------------\n"
      sortedCountries.first(10).each { |key, value| tmpText += "#{key} : #{value}\n" }
      tmpText += "\n"

      (categoryName.nil? ? FilesCreation.new.createFile(Time.now.strftime("%d_%m_%Y") + "_topcountries", tmpText) : FilesCreation.new.createFile(Time.now.strftime("%d_%m_%Y") + "_topcountries_on_" + categoryName.downcase, tmpText))
      puts tmpText
    end

    puts ".. End of Soundcloud Report .."
  end
end