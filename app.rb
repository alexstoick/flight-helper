require 'net/http'
require 'uri'
require 'json'
require 'pry'
require 'openssl'
require './itinerary'
require './leg'
require './carrier'
require './place'

url = "http://partners.api.skyscanner.net/";

uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new "/apiservices/pricing/v1.0/"
request.add_field("Content-Type", "application/json")


originplace = "OTP"
destination = "LHR"
outbounddate = "2016-09-14"
hash = {
  "country" => "GB",
  "currency" => "GBP",
  "locale" => "en-GB",
  "adults" => 1,
  "locationschema" => "iata",
  "apiKey" => "as608214569904935675848799169473",
  "originplace" => "OTP",
  "destinationplace" => "LHR",
  "outbounddate" => "2016-09-14",
}

request.set_form_data(hash)


response = http.request(request)
url_to_track = response.to_hash["location"][0]
url_to_track = url_to_track + "?apiKey=as608214569904935675848799169473"

url = URI.parse(url_to_track)
req = Net::HTTP.get(url)

#File.open("thing.json", "w") { |f| f.write(req) }
#h = JSON.parse(open("thing.json").read)
h = JSON.parse(req)

itineraries = h["Itineraries"].collect { |hh| Itinerary.new(hh) }
legs = h["Legs"].collect { |hh| Leg.new(hh) }
carriers = h["Carriers"].collect { |hh| Carrier.new(hh) }
places = h["Places"].collect { |hh| Place.new(hh) }

results = itineraries.collect do |it|
  outbound_leg = legs.select { |leg| leg.id == it.outbound_leg_id }.first
  outbound_carrier = carriers.select { |c| c.id == outbound_leg.carriers[0] }
  it.outbound_leg = outbound_leg
  it.outbound_carrier = outbound_carrier.first
  it.origin = places.select { |p| p.id == outbound_leg.origin_id }.first
  it.destination = places.select { |p| p.id == outbound_leg.destination_id }.first
  it
end

results.select! { |r| r.stops == 0 }
results.sort! { |a,b| a.price <=> b.price }
(0..5).each do |i|
  p results[i].to_json
end
