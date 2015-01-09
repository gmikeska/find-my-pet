require 'sinatra'
	require 'sinatra/reloader'
#require 'rest-client'
require 'json'
require 'bcrypt'
require 'rack-flash'
require_relative 'config/environments.rb'

module FindMyPet
	class Server < Sinatra::Application
		configure do
		    enable :sessions
		    use Rack::Flash
		  end

		before do
			if session['user_id']
				@user_id = session['user_id']
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
			@params = params
			password = params['password']
			confirm = params['confirm']
			email = params['email']
			if(password == confirm)
				a = User.new(params)
				a.save!
				redirect to '/'
			else
				flash.now[:alert] = "Please confirm your password."
			end
			#print success message to screen
			erb :"auth/signup"
		end

		get '/signin' do
			@page_title = "Sign In! - FindMyPet"
			
			erb :"auth/signin"
		end

		get '/home' do

			erb :home
		end

		get '/signout' do

			session.clear
			redirect to '/'
		end

		post '/signin' do
			JSON.generate params
		 #params: email, password
		 user = User.find_by(email_address: params['email'])
		 if user["password"] == params["password"]
		 	session['user_id'] = user['id']
		 	redirect to '/'
		 else
		 	redirect to '/signin'
		 end
		end

		get '/lost/:id' do
			#return specific lost animal bulletin, and comments
			MissingPet.find(params[:id])
		end

		post '/lost' do
		 	#create a new bulletin for a lost pet
		 	a = params
		 	MissingPet.save(a)
		 	redirect to '/'
		end

		post '/found' do
		 	#create a new bulletin for a found pet
		 	a = params
		 	FoundPet.save(a)
		 	redirect to '/'
		end

		get '/found/:id' do
			#return specific found pet bulletin with comments
			FoundPet.find(params[:id])

		end

		post '/message' do
		 	#post new discussion message to a lost/found bulletin
		 	#params: post id, user id
		 end


		

	end
end