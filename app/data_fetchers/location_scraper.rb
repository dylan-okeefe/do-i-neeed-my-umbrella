
class LocationScraper
  attr_reader :woeid_search, :location_model

  def initialize(cli_obj)
    @woeid_search = Nokogiri::HTML(open("http://woeid.rosselliot.co.nz/lookup/#{cli_obj.location.downcase.split(" ").join("%20")}"))
  end

  def create_model
    @location_model = LocationData.new(@woeid_search)
  end

end
