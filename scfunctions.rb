require './files_creation'
require 'colorize'
require 'json'
require './geocodes'

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
        @Countries[countryname]["Value"] += 1
      else
        @Countries[countryname] = {}
        @Countries[countryname]["Value"] = 1
      end

      if not $options[:geo].nil?
        @Countries[countryname]["geolocation"] = Geocodes.new.search(countryname)
      end
    end
  end

  def getSoundCategories(categoryName = nil, json = nil, geocode = nil)
    (categoryName.nil? ? $client.get('/explore/sounds/category', :limit => '10') :
        $optionName == "category" ?
            $client.get('/explore/sounds/category/', :q => categoryName.downcase, :limit => '10') :
            $client.get('/explore/sounds/category/' + categoryName.downcase, :limit => '10'))
    rescue => e
      case e.message
        when "HTTP status: 401 Unauthorized"
          putErrMessage("Soundcloud Connection Problem. Please check your Client ID".colorize(:red), json)
          exit
        else
          putErrMessage("Category Problem. You should check your category name\n".colorize(:red), json)
          exit
      end
  end

  def getCountries
    @Countries
  end

  def render(categoryName = nil, json = nil, geocode = nil)
    expCategory = getSoundCategories(categoryName, json, geocode)

    if $optionName == "category"
      filename = Time.now.strftime("%d%m%Y") + "_topcountries_on_" + $options[:category].downcase + "_only"
    elsif $optionName == "similar"
      filename = Time.now.strftime("%d%m%Y") + "_topcountries_on_" + $options[:similar].downcase + "_similar"
    else
      filename = Time.now.strftime("%d%m%Y") + "_topcountries_on_all_categories"
    end

    foundCategory = false
    expCategory.collection.each_with_index do |category, index|
      if $optionName == "category"
        if category.name != categoryName
          if index+1 == expCategory.collection.length and not foundCategory
            putErrMessage("No Record Found".colorize(:red), json)
            exit
          else
            next
          end
        else
          foundCategory = true
        end
      end

      category.tracks.each do |track|
        countryname = getUserCountry(getTrackUser(track.id))
        increaseCountryCount(countryname)
      end

      sortedCountries = Hash[getCountries.sort_by{ |k, v|
        -v["Value"]
      }]

      if json.nil?
        createText(category.name, sortedCountries, json, filename)
      else
        if @fromHash.nil?
          @fromHash = Hash.new()
          @fromHash["header"] = "Top " + sortedCountries.first(10).length.to_s + " Countries on " + category.name + " Category"
          @fromHash["categories"] = Hash.new()
        end

        @fromHash["categories"][category.name] = sortedCountries
      end

      if not $options[:limit].nil? and index+1 == $options[:limit].to_i
        break
      end
    end

    if not @fromHash.nil?
      tmpText = @fromHash.to_json
      puts tmpText
      unless $options[:file].nil?
        FilesCreation.new.createFile(filename + "_json", tmpText)
      end
      puts "\n"
    end
  end

  def createText(categoryname, collection, json, filename)
    if json.nil?
      header = "Top " + collection.first(10).length.to_s + " Countries on "+ categoryname +" Category\n"
      tmpText = header.colorize(:yellow) +
          "-----------------------------------------\n".colorize(:yellow)

      i = 1
      collection.first(10).each { |key, value|
        if $options[:geo].nil? then
          tmpText += selectColor("#{key} : #{value["Value"]}\n", i)
        else
          tmpText += selectColor("#{key} : #{value["Value"]} [Geocode: #{value["geolocation"][:latitude]}, #{value["geolocation"][:longitude]}]\n", i)
        end

        i+=1
      }

      tmpText += "\n"
      puts tmpText

      unless $options[:file].nil?
        tmpText = header +
            "-----------------------------------------\n"
        collection.first(10).each { |key, value| tmpText += "#{key} : #{value}\n" }
        tmpText += "\n"
        FilesCreation.new.createFile(filename, tmpText)
      end
    end
  end

  def putErrMessage(text, json = nil)
    if json.nil?
      puts "\n" + text + "\n"
    else
      puts "{\"message\": \"" + text + "\"}"
    end
  end

  def selectColor(text, index)
    case index
      when 1
        text.colorize(:green)
      when 2
        text.colorize(:light_green)
      when 3
        text.colorize(:light_yellow)
      else
        text
    end
  end
end