require 'geokit'
require 'pg'

module GEO

  # main call
  def self.geocode(address)
    Geokit::Geocoders::GoogleGeocoder.geocode address
  end

  def self.getWithinRadius radius, myLongitude, myLatitude, tablename

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

    #
    # Sample Call
    # GEO::getWithinRadius(0.1, -97.7181049, 30.2476846, 'lost', 'findmypet')
    # GEO::getWithinRadius(5, -97.7181049, 30.2476846, 'lost', 'findmypet')
    #

    db = PG.connect(host: 'localhost', dbname: 'findmypet')

    sql = "SELECT * FROM #{tablename}"
    results = db.exec(sql)

    resultsArray = Array.new

    if (results.count <= 0)  
      puts "no data"
    else
      resultsArray = Array.new    # return array
      myLocation = Geokit::LatLng.new(myLongitude, myLatitude)

      results.each do |result|
        # puts "(x, y): " + "#{result['where_longitude']}" + ", " + "#{result['where_latitude']}"

        theirLocation = Geokit::LatLng.new("#{result['where_longitude']}", "#{result['where_latitude']}")
        distance = myLocation.distance_to(theirLocation)

        puts "Distance: " + distance.to_s
        if (distance <= radius.to_f) 
          resultsArray.push("#{result['user_id']}".to_i)
        end
      end
    end
    puts resultsArray
    return resultsArray
  end
end
