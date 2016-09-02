class Leg
  attr_reader :id,:departure, :arrival, :carriers, :stops, :duration,
    :origin_id, :destination_id

  def initialize(json)
    @id = json["Id"]
    @departure = json["Departure"]
    @arrival = json["Arrival"]
    @stops = json["Stops"].count
    @carriers = json["OperatingCarriers"]
    @duration = json["Duration"]
    @origin_id = json["OriginStation"]
    @destination_id = json["DestinationStation"]
  end
end
