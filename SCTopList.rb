#!/usr/bin/env ruby

# == Synopsis
#   This is created for Soundcloud Contest but you can use it on your projects easily.
#
#   You can use it for getting all information about Countries and Music Genres. It gives which countries are on top list on any genre. Also you can filter data with app options, get data in json format, create text file and get data with Geolocation of countries.
#
# == Examples
#   This command does show all top countries of all genres in json format with geolocation info
#     ruby SCTopList.rb -a -j -g
#
#   This command does show all top countries of any similar genres
#     ruby SCTopList.rb -s Rock
#
#   Other examples:
#     ruby SCTopList.rb -l 100 -c Rock
#     ruby SCTopList.rb -s Rock -f
#
# == Usage
#   Firstly, enter your **Soundcloud Client ID** to **SCTopList.rb**
#   After that, run this command : **bundle install**
#   ruby SCTopList.rb [options]
#
#   For help use: ruby SCTopList.rb -h
#
# == Options
#   -a, --all                     Show All Categories
#   -s <similar>, --similar       Show Similar Categories
#   -c <category>, --category     Show This Category Only
#   -j, --json                    Show Data in JSON
#   -g, --geo                     Show Data with Location Parameters
#   -f, --file                    Create Report File
#   -l <limit>, --limit           Max number of Categories (recommended)
#
# == Author
#   İlker Güller
#
# == Copyright
#   (c) 2013 İlker Güller

require 'soundcloud'
require './scfunctions'
require 'optparse'
require './cli'

VERSION = "0.0.1"

$clientid = 'CLIENT_ID' # You must change this with your Client ID before use it
$client = Soundcloud.new(:client_id => $clientid)
$scFuncs = Scfunctions.new($client)
$options = {}

cli = Cli.new