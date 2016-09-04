require 'date'
class Leg
  attr_reader :id,:departure, :arrival, :carriers, :stops, :duration,
    :origin_id, :destination_id, :time_difference

  def initialize(json)
    @id = json["Id"]
    @departure = DateTime.parse(json["Departure"])
    @arrival = DateTime.parse(json["Arrival"])
    @stops = json["Stops"].count
    @carriers = json["OperatingCarriers"]
    @duration = json["Duration"]
    @origin_id = json["OriginStation"]
    @destination_id = json["DestinationStation"]
    @time_difference = distance_of_time_in_hours_and_minutes(@duration)
  end

  private

  def distance_of_time_in_hours_and_minutes(dist)
    minutes = dist.abs
    hours = minutes / 60
    minutes = minutes - (hours * 60)

    words = ""

    words << "#{hours} #{hours > 1 ? 'hours' : 'hour' } and " if hours > 0
    words << "#{minutes} #{minutes == 1 ? 'minute' : 'minutes' }"
  end
end
