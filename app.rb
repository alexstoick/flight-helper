require 'net/http'
require 'uri'
require 'json'
require 'pry'
require 'openssl'
require './itinerary'
require './leg'
require './carrier'
require './place'
require './helper'
include Helper

res = make_request("DUB", "LHR", "2016-09-30")#, "2016-10-01")
results = parse_result(res)

results.select! { |r| r.stops == 0 }
results.sort! { |a,b| a.price <=> b.price }
(0..5).each do |i|
  pp results[i].to_json
end

#airports = ["London City", "London Heathrow"]
#results.select! do |r|
  #ok = airports.include?(r.outbound_origin.name)
  #if r.inbound_destination
    #ok = ok && airports.include?(r.inbound_destination.name)
  #end
  #ok
#end

#pp
#pp
#pp
#pp
#pp
#pp

#(0..5).each do |i|
  #pp results[i].to_json
#end
