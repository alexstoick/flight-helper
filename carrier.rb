class Carrier
  attr_reader :id, :name

  def initialize(json)
    @id = json["Id"]
    @name = json["Name"]
  end
end
