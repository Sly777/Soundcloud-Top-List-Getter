#!/usr/bin/env ruby
require 'soundcloud'
require './scfunctions'
require 'optparse'
require './cli'

$clientid = 'CLIENTID' # You must change this with your Client ID before use it
$client = Soundcloud.new(:client_id => $clientid)
$scFuncs = Scfunctions.new($client)
$options = {}

cli = Cli.new