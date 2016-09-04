module Helper
  def make_request(depature, arrival, dep_date, arr_date = nil)
    url = "http://partners.api.skyscanner.net/";

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new "/apiservices/pricing/v1.0/"
    request.add_field("Content-Type", "application/json")

    hash = {
      "country" => "GB",
      "currency" => "GBP",
      "locale" => "en-GB",
      "adults" => 1,
      "locationschema" => "iata",
      "apiKey" => "as608214569904935675848799169473",
      "originplace" => depature,
      "destinationplace" => arrival,
      "outbounddate" => dep_date,
    }
    if arr_date
      hash.merge!(
        "inbounddate" => arr_date,
      )
    end

    request.set_form_data(hash)


    response = http.request(request)
    url_to_track = response.to_hash["location"][0]
    url_to_track = url_to_track + "?apiKey=as608214569904935675848799169473"

    url = URI.parse(url_to_track)
    req = Net::HTTP.get(url)

    #File.open("thing.json", "w") { |f| f.write(req) }
    #h = JSON.parse(open("thing.json").read)
    JSON.parse(req)
  end


  def parse_result(h)
    itineraries = h["Itineraries"].collect { |hh| Itinerary.new(hh) }
    legs = h["Legs"].collect { |hh| Leg.new(hh) }
    carriers = h["Carriers"].collect { |hh| Carrier.new(hh) }
    places = h["Places"].collect { |hh| Place.new(hh) }

    results = itineraries.collect do |it|
      outbound_leg = legs.select { |leg| leg.id == it.outbound_leg_id }.first
      outbound_carrier = carriers.select { |c| c.id == outbound_leg.carriers[0] }
      inbound_leg = legs.select { |leg| leg.id == it.inbound_leg_id }.first
      if inbound_leg
        inbound_carrier = carriers.select { |c| c.id == inbound_leg.carriers[0] }.first

        it.inbound_leg = inbound_leg
        it.inbound_carrier = inbound_carrier
        it.inbound_origin = places.select { |p| p.id == inbound_leg.origin_id }.first
        it.inbound_destination = places.select { |p| p.id == inbound_leg.destination_id }.first
      end
      it.outbound_leg = outbound_leg
      it.outbound_carrier = outbound_carrier.first

      it.outbound_origin = places.select { |p| p.id == outbound_leg.origin_id }.first
      it.outbound_destination = places.select { |p| p.id == outbound_leg.destination_id }.first

      it
    end

    results
  end

end
