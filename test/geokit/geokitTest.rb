require 'geokit'
require 'pg'

module GEO

  # main call
  def self.geocode(address)
    Geokit::Geocoders::GoogleGeocoder.geocode address
  end

  # sample call
  def self.geocodeThese

    addresses = ['716 S Congress, Austin, TX',
                 'University of Texas, Austin, TX',
                 'Pflugerille, TX',
                 'Town Lake, Austin, TX',
                 'Round Rock, TX',
                 '6th St, Austin, TX',
                 'Capital Building, Austin, TX',
                 ' 3rd Street, Austin, TX',
                 '18th Street and I-35, Austin, TX',
                 '74012']

    addresses.each do |address|
      result = Geokit::Geocoders::GoogleGeocoder.geocode address
      puts "======================================="
      puts "Input: " + address
      puts "Results: "
      puts "   success:    " + result.success.to_s
      puts "   longitue:   " + result.lng.to_s
      puts "   latitude:   " + result.lat.to_s
      puts "   precision:  " + result.precision
    end
    puts
  end

  def self.getWithinRadius radius, myLongitude, myLatitude, tablename, database

    # Description: getWithinRadius
    # - Given a location and radius (miles), find all records in a table that are within
    # - the radius. 
    #
    # Input:
    # - radius ==> miles
    # - myLongitude, myLatitude ==> location in decimal degrees (i.e. -97.7475944, 30.2552373)
    # - tablename ==> lost or found (must contain longitude and latitude columns)
    #                 should work with any table with id, longitude and latitude columns
    # - database ==> db where tablename exists
    #
    # Return: array of 'id' from tablename; blank array if nothing
    #

    db = PG.connect(host: 'localhost', dbname: database)

    sql = "SELECT * FROM #{tablename}"
    results = db.exec(sql)

    resultsArray = Array.new

    if (results.count <= 0)  
      puts "no data"
    else
      resultsArray = Array.new
      myLocation = Geokit::LatLng.new(myLongitude, myLatitude)

      results.each do |result|
        puts "(x, y): " + "#{result['where_longitude']}" + ", " + "#{result['where_latitude']}"

        theirLocation = Geokit::LatLng.new("#{result['where_longitude']}", "#{result['where_latitude']}")
        distance = myLocation.distance_to(theirLocation)
        puts "Distance: " + distance.to_s

        if (distance <= radius) 
          resultsArray.push("#{result['user_id']}".to_i)
        end
      end

    end
puts resultsArray
    return resultsArray
  end


  def self.getWithinRadiusTest
    # sample distance call
    myLocation = Geokit::LatLng.new(30.2552373, -97.7475944)  # MakerSquare
    theirLocation = Geokit::LatLng.new(30.2836029, -97.7228306) # UT
    distance = myLocation.distance_to(theirLocation)
    puts distance #(in miles)
  end 
end
