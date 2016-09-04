class Itinerary
  attr_reader :outbound_leg_id, :inbound_leg_id, :price, :deeplink_url
  attr_accessor :outbound_leg
  attr_accessor :outbound_carrier
  attr_accessor :inbound_origin, :inbound_destination
  attr_accessor :outbound_origin, :outbound_destination
  attr_accessor :inbound_leg, :inbound_carrier

  def initialize(json)
    @outbound_leg_id = json["OutboundLegId"]
    @inbound_leg_id = json["InboundLegId"]
    pricing_option = json["PricingOptions"][0]
    @price = pricing_option["Price"]
    @deeplink_url = pricing_option["DeeplinkUrl"]
  end

  def stops
    outbound_leg.stops
  end

  def to_json
    hash = default_hash
    if inbound_leg
      hash.merge!(
        {
          inbound_carrier: inbound_carrier.name,
          inbound: "#{inbound_origin.name} - #{inbound_destination.name}",
          inbound_time: "#{inbound_leg.time_difference}",
          inbound_departure: "#{inbound_leg.parsed_departure}",
        }
      )
    end
    hash
  end

  private
  def default_hash
    {
      price: price,
      stops: stops,
      outbound_carrier: outbound_carrier.name,
      outbound: "#{outbound_origin.name} - #{outbound_destination.name}",
      outbound_time: "#{outbound_leg.time_difference}",
      outbound_departure: "#{outbound_leg.parsed_departure}",
    }
  end
end
