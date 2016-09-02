class Itinerary
  attr_reader :outbound_leg_id, :price, :deeplink_url
  attr_accessor :outbound_leg
  attr_accessor :outbound_carrier
  attr_accessor :origin, :destination
  def initialize(json)
    @outbound_leg_id = json["OutboundLegId"]
    pricing_option = json["PricingOptions"][0]
    @price = pricing_option["Price"]
    @deeplink_url = pricing_option["DeeplinkUrl"]
  end

  def stops
    outbound_leg.stops
  end

  def to_json
    {
      price: price,
      stops: stops,
      outbound_carrier: outbound_carrier.name,
      departure: outbound_leg.departure,
      arrival: outbound_leg.arrival,
      origin: origin.name,
      destination: destination.name,
    }
  end
end
