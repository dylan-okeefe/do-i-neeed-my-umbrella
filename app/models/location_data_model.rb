class LocationData
  attr_reader :city, :state, :country, :woeid, :location_count

  attr_accessor :example

  def initialize(data)
    @parsed_html = data
  end


  def grab_values(counter)
    @location_count = 0
    if !@parsed_html.css('tr.woeid_row')[counter].nil?
      @location_array = []
      @city = @parsed_html.css('tr.woeid_row')[counter].children[0].text
      @state = @parsed_html.css('tr.woeid_row')[counter].children[1].text
      @country = @parsed_html.css('tr.woeid_row')[counter].children[2].text
      @woeid = @parsed_html.css('tr.woeid_row')[counter].children[3].text.to_i
      @location_count = @parsed_html.css('tr.woeid_row').count
    end
  end

end