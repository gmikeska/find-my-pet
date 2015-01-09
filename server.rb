require 'sinatra'
	require 'sinatra/reloader'
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

		get '/' do
			if session['user_id']
				erb :index				
			else
			  @mission_statement = File.read('views/readins/mission statement.erb')
			erb :index, :locals=> {ms: @mission_statement}
			end

		end

		get '/signup' do
			@page_title = "Sign Up! - FindMyPet"
			erb :"auth/signup"
		end

		post '/signup' do
			#params: username, email

		end

		get '/signin' do

			@page_title = "Sign In! - FindMyPet"
			erb :"auth/signin"
		end

		post '/signin' do
		 #params: username, email
		 #return: 
		end

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