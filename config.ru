# This file is used by Rack-based servers to start the application.
require './server'
#require ::File.expand_path('../config/environment',  __FILE__)
run FindMyPet::Server
