require 'pg'

# Find My Pet - Hackathon
#
# createdb 'find_my_pet'
# irb
# db = FMP::create_db_connection('find_my_pet')
# FMP::create_tables db
# FMP::seed_tables db
#
# Subsequently for db updates: FMP::do_it('find_my_pet')




module FMP

  def self.create_db(dbname)
    success = system("createdb #{dbname}")
  end

  def self.create_db_connection dbname
    PG.connect(host: 'localhost', dbname: dbname)
  end

  #
  # this may work if you already have your db and tables
  #
  def self.do_it(dbname)
    db = self.create_db_connection(dbname)
    self.clear db
    self.drop_tables db
    self.create_tables db
    self.seed_tables db
  end

  def self.clear db
    db.exec <<-SQL
      DELETE FROM lost_images;
      DELETE FROM found_images;
      --DELETE FROM images;
      DELETE FROM lost_messages;
      DELETE FROM found_messages;
      DELETE FROM lost;
      DELETE FROM found;
      DELETE FROM users;
    SQL
  end

  ##################################################################################
  def self.create_tables db
    db.exec <<-SQL

      --##################################################################################
      --# users table
      --##################################################################################
      CREATE TABLE IF NOT EXISTS users(
        id SERIAL PRIMARY KEY,
        name VARCHAR,
        email_address VARCHAR,
        password VARCHAR,
        street_address VARCHAR,
        city VARCHAR,
        state VARCHAR,
        zipcode VARCHAR,
        longitude NUMERIC,
        latitude NUMERIC,
        phone_home VARCHAR,
        phone_cell VARCHAR,
        fb_account VARCHAR,
        fb_token VARCHAR,
        radius NUMERIC
      );

      --##################################################################################
      --# contains lost animal records (i.e. I lost this animal)
      --##################################################################################
      CREATE TABLE IF NOT EXISTS lost(
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users (id),
        name VARCHAR,
        animal_type VARCHAR,
        animal_breed VARCHAR,
        animal_gender VARCHAR,
        comment VARCHAR,
        is_lost BOOLEAN,
        date_lost TIMESTAMP,
        where_lost VARCHAR,
        where_longitude NUMERIC,
        where_latitude NUMERIC,
        chip_manufacturer VARCHAR,
        chip_id VARCHAR,
        other VARCHAR,
        created TIMESTAMP
      );

      --##################################################################################
      --# constains found animal records (i.e. I found this animal)
      --##########
      CREATE TABLE IF NOT EXISTS found(
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users (id),
        name VARCHAR,
        animal_type VARCHAR,
        animal_breed VARCHAR,
        animal_gender VARCHAR,
        comment VARCHAR,
        is_found BOOLEAN,
        date_found TIMESTAMP,
        where_found VARCHAR,
        where_longitude NUMERIC,
        where_latitude NUMERIC,
        chip_manufacturer VARCHAR,
        chip_id VARCHAR,
        other VARCHAR,
        created TIMESTAMP
      );

      --##################################################################################
      --# ideally have a single messages table and use polymorphic associations
      --##################################################################################
      CREATE TABLE IF NOT EXISTS lost_messages(
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users (id),
        animal_id INTEGER REFERENCES lost (id),
        message VARCHAR,
        last_location VARCHAR,
        last_longitude NUMERIC,
        last_latitude NUMERIC,
        created TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS found_messages(
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users (id),
        animal_id INTEGER REFERENCES found (id),
        message VARCHAR,
        last_location VARCHAR,
        last_longitude NUMERIC,
        last_latitude NUMERIC,
        created TIMESTAMP
      );
      --##################################################################################
      
      CREATE TABLE IF NOT EXISTS lost_images(
        id SERIAL PRIMARY KEY,
        animal_id INTEGER REFERENCES lost (id),
        image_url VARCHAR
      );

      CREATE TABLE IF NOT EXISTS found_images(
        id SERIAL PRIMARY KEY,
        animal_id INTEGER REFERENCES found (id),
        image_url VARCHAR
      );
    SQL
  end

  def self.drop_tables db
    db.exec <<-SQL
      DROP TABLE users CASCADE;
      DROP TABLE lost CASCADE;
      DROP TABLE found CASCADE;
      DROP TABLE lost_messages CASCADE;
      DROP TABLE found_messages CASCADE;
      --DROP TABLE images;
      DROP TABLE lost_images CASCADE;
      DROP TABLE found_images CASCADE;
    SQL
  end

  def self.seed_tables db

    db.exec <<-SQL
      -- users
      INSERT INTO users (name, email_address, password, street_address, city, state, zipcode, longitude, latitude, radius)
        VALUES ('Greg H','greghorne@hotmail.com','1234', '1116 S Tamarack Ave', 'Broken Arrow', 'OK','74012', -95.7932008, 36.05826630000001, 5);

      INSERT INTO users (name, email_address, password, street_address, city, state, zipcode,longitude, latitude, radius)
        VALUES ('Julia','julia@pets.com','1234', '716 Congress Ave', 'Austin', 'TX','', -97.7475944, 30.2552373, 6);

      INSERT INTO users (name, email_address, password, street_address, city, state, zipcode,longitude, latitude, radius)
        VALUES ('Greg M','greg@bitcoin.com','1234', 'Town Lake', 'Austin', 'TX','', -97.7181049, 30.2476846, 4);
      
      -- lost
      INSERT INTO lost (name,user_id, animal_type, animal_breed, animal_gender, comment, is_lost,
        date_lost, where_lost, chip_manufacturer, chip_id, other, created, where_longitude, where_latitude)
        VALUES ('Fido', 1, 'Dog', 'German Shorthaired Pointer', 'Male', 'friendly, orange collar', TRUE, 
          clock_timestamp(), 'UT, Austin, TX', 'Joes Dog Chips', 'ABCD9876', 'White, brown spots', 
          clock_timestamp(), -97.7228306, 30.2836029);
      INSERT INTO lost (name, user_id, animal_type, animal_breed, animal_gender, comment, is_lost,
        date_lost, where_lost, chip_manufacturer, chip_id, other, created, where_longitude, where_latitude)
        VALUES ('Fluffy',2, 'Cat', 'White Cat', 'Female', 'fearsome, attacks on command', TRUE, 
          clock_timestamp(), '6th Street, Austin, TX', '', '', '', 
          clock_timestamp(), -97.6669354, 30.2020868);  
      
      -- found
      INSERT INTO found (user_id, animal_type, animal_breed, animal_gender, comment, is_found,
        date_found, where_found, chip_manufacturer, chip_id, other, created, where_longitude, where_latitude)
        VALUES (1, 'Dog', 'Pit Bull', 'Female', 'young; injured paw, no collar, very friendly', TRUE, 
          clock_timestamp(), 'UT Area, Austin, TX', '', '', '', 
          clock_timestamp(), -97.7228306, 30.2836029);  

      -- lost_messages
      INSERT INTO lost_messages (animal_id, message, last_location, created)
        VALUES (2, 'I may have seen your dog hanging out on 5th street', '5th street', clock_timestamp());
      
      -- found messages
      INSERT INTO found_messages (animal_id, message, last_location, created)
        VALUES (1, 'Does the pit bull have a mark above left eye?', '', clock_timestamp());
      -- lost_images
      INSERT INTO lost_images (animal_id, image_url) VALUES (1, 'http://2.bp.blogspot.com/_YGZsB8JQLfQ/S9OqhNSsuLI/AAAAAAAAA6k/631FUM5efM0/s1600/Greater+Swiss+Mountain_003.jpg')
    SQL

  end
end