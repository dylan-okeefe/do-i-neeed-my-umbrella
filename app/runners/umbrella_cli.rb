
class UmbrellaCLI
  attr_reader :location

  #greet the user
  def greeting
    puts "----------------------------------"
    puts "Do you need an umbrella this week?"
    puts "----------------------------------"
  end


  def saved_location?
    if File.size?('location.JSON').nil?
      false
    else
      true
    end
  end

  def correct_saved_location?
    location = File.read('location.JSON')
    location_hash = JSON.parse(location)
    puts "Are you still located in #{location_hash["city"]}, #{location_hash["state"]}, #{location_hash["country"]}?"
    response_valid = false
    until response_valid
    usr_input = gets.chomp
      if usr_input.downcase == "yes"
        response_valid = true
        return true
      elsif usr_input.downcase == "no"
        response_valid = true
        return false
      else
        puts "Please enter yes or no."
      end
    end
  end

  def get_location
    @location_accepted = false
    until @location_accepted
      puts "Where are you located?"
      @location = gets.chomp
      if !!((/[\.\,\_\-]/) =~ @location) 
        puts "Please don't use punctuation"
      elsif !@location.is_a?String
        puts "Please enter only text"
      elsif !!((/[\d]/) =~ @location) 
        puts "Please enter only text"
      elsif @location.is_a?String 
        puts "Thank you!"
        @location_accepted = true
      end
    end
  end

  def create_scraper
    @scraper_instance = LocationScraper.new(self)
  end

  def load_model
    @location_model = @scraper_instance.create_model
  end

  def load_current_location_option
    @location_model.grab_values(@location_counter)
  end

  def list_over?
    if @location_counter >= @location_model.location_count
        puts "Sorry, I've run out of locations. Please search again."
        self.get_location
        self.create_scraper
        @location_counter = 0
    end
  end


  def correct_location?
    if @location_model.city.nil? && @location_model.state.nil? && @location_model.nil?
      @location_counter +=1
      self.load_current_location_option
    end
    self.load_current_location_option
    puts "Is #{@location_model.city}, #{@location_model.state}, #{@location_model.country} your location?"
      @response = gets.chomp
  end


  def validate_input
    response_valid = false
    while !response_valid
      if @response.downcase == "no"
          response_valid = true
          @location_counter += 1
      elsif @response.downcase == "yes"
          puts "Great. Location set to #{@location_model.city}, #{@location_model.state}, #{@location_model.country}."
          location_hash =  { :city => "#{@location_model.city}",
                            :state => "#{@location_model.state}", 
                            :country => "#{@location_model.country}", 
                            :woeid => @location_model.woeid}
          File.open('location.JSON', 'w') do |file|
            file.write(location_hash.to_json)
          end
          response_valid = true
          @location_found = true
          30.times do 
            print "."
            sleep 0.05
          end
          puts "\n"
          break
      else
          puts "Please enter yes or no."
          break
      end
    end
  end

  def validate_location
    @location_counter = 0
    @location_found = false
    until @location_found
      self.create_scraper
      self.load_model
      self.load_current_location_option
      self.list_over?
      self.correct_location?
      self.validate_input
    end
  end

  def location_grab
    self.get_location
    # self.search
    self.validate_location
  end 

  def case_checks
    self.greeting
    case self.saved_location?
      when true
        case self.correct_saved_location?
          when true
            return self.woeid
          when false
            self.location_grab
          end
      when false
        self.location_grab
    end
  end

  def run
    self.case_checks
    self.woeid
    @weather_read_out = Weather.new(@woeid)
    @weather_read_out.compile
    @weather_read_out.results
  end

  def woeid
    location = File.read('location.JSON')
    location_hash = JSON.parse(location)
    @woeid = location_hash["woeid"]
    return @woeid
  end

end