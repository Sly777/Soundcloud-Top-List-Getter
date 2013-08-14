#!/usr/bin/env ruby
require 'soundcloud'
require './scfunctions'
require 'optparse'

$clientid = 'CLIENTID' # You must change this with your Client ID before use it
$client = Soundcloud.new(:client_id => $clientid)
$scFuncs = Scfunctions.new($client)
options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "\n----------------- Soundcloud Top List Getter -----------------\n"+
                "Usage: SCTopList.rb [options]"

  opts.separator ""
  opts.separator "Specific options:"

  opts.on("-a", "--all", "Show All Categories") do
    options[:all] = true
    $scFuncs.render
  end

  opts.on("-c <category>", "--category", "Show This Category Only") do |category|
    options["country"] = category
    $scFuncs.render(category)
  end

  opts.on("-h", "--help", "Help") do
    puts optparse
    exit
  end

  opts.separator ""
  opts.separator "--------------------------------------------------------------"
  opts.separator ""
end

begin
  optparse.parse!

  mandatory = [:a, :c]
  missing = mandatory.select{ |param| options[param].nil? }
  if not missing.empty?

    puts optparse
    exit
  end

  rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s
  puts optparse
  exit
end