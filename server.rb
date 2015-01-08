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

		get '/signup' do

		end

		post 'signup' do
			#params: username, email
		end

		get 'signin' do
		end

		post 'signin' do
		 #params: username, email
		 #return: 

		post '/lost' do
		 	#create a new bulletin for a post pet
		end

		post '/found' do
		 	#create a new bulletin for a found pet
		end

		post '/message' do
		 	#post new discussion message to a lost/found bulletin
		 	#params: post id, user id
		 end


		 end

		end
	end
end