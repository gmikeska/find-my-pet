require 'sinatra'
# require 'sinatra/reloader'
#require 'rest-client'
require 'json'
require 'bcrypt'
require_relative 'config/environments.rb'

module FindMyPet
	class Server < Sinatra::Application
		configure do
		    enable :sessions
		  end

		before do
			if session['user_id']
				user_id = session['user_id']
			end
		 end
		# #
		# This is our only html view...
		#
		get '/' do
		  	erb :index
		end
	end
end