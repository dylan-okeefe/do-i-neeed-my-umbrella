

class Weather

  attr_reader :url,:bring_it, :maybe_bring_it, :forecast_data

  IT_WILL_RAIN =*(1..12)
  CHANCE_OF_RAIN = [37,39,38,40,47]


  def initialize(weiod = 222459115)
    @url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%3D#{weiod}&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    @bring_it = []
    @maybe_bring_it = []
  end

  def generate_data
    weather_info = RestClient.get url
    weather_info = JSON.parse(weather_info)
    @forecast_data = weather_info["query"]["results"]["channel"]["item"]["forecast"]
  end

      
  def sort
    @forecast_data.each do |hash_of_day|
      if IT_WILL_RAIN.include?(hash_of_day["code"].to_i)
        @bring_it << hash_of_day["day"]
      elsif CHANCE_OF_RAIN.include?(hash_of_day["code"].to_i)
        @maybe_bring_it << hash_of_day["day"]
      else
        next
      end
    end
  end

  def layout(array)
    if array.length >= 3
      @layout = array[0..-3].join(", ") + " " + array[-2] + " and " + array[-1]
    elsif array.length == 2
      @layout = array[0] + " and " + array[1]
    elsif array.length == 1
      @layout = array[0]
    end
  end

  def compile
    self.generate_data
    self.sort
  end

  def results
    if @bring_it.length > 0 && @maybe_bring_it.length > 0
      puts "It might be a good idea to bring an umbrella on " + layout(@bring_it)
      puts "Maybe bring it " + layout(@maybe_bring_it)
    elsif @bring_it.length > 0
      puts "It might be a good idea to bring an umbrella on " + layout(@bring_it)
    elsif @maybe_bring_it.length > 0
      # binding.pry
      puts "Maybe bring it " + layout(@maybe_bring_it)
    else
      puts "You don't need your umbrella this week!"
    end
  end
  
end

