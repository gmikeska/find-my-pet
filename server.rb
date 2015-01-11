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
				@user = User.find(@user_id)
			end
		 end

		get '/' do
			if session['user_id']
				# if @user.activation
				# 	erb :"auth/activation"
				# else
				# 	erb :home
				# end				
				postst = MissingPet.all
				@posts = postst.to_json
				# puts @posts
				erb :index
			else
			  @mission_statement = File.read('views/readins/mission statement.erb')
				postst = MissingPet.all
				@posts = postst.to_json
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
				params['activation'] = (0...8).map { (65 + rand(26)).chr }.join
				params.delete('confirm')
				params.delete('radius')
				params['street_address'] = params['address']
				params.delete('address')
				params['email_address'] = params['email']
				params.delete('email')
				a = User.new(params)
				a.save!
				#a.send_activation
				session['user_id'] = a.id
				redirect to "/activation"
			else
				flash.now[:alert] = "Please confirm your password."
				erb :"auth/signup"
			end
			#print success message to screen
		end
		get '/activation' do
			if params['activation']
				u = User.find_by(activation: params["activation"])
				if @user_id == u.id
					u.activation = nil;
					u.save!()
					redirect to '/'
				end
			end
			erb :"auth/activation"
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
		 #params: email, password
		 user = User.find_by(email_address: params["email"])
		 if user["password"] == params["password"]
		 	session['user_id'] = user['id']
		 	redirect to '/'
		 else
		 	redirect to '/signin'
		 end
		end

		get '/profile' do
			#return specific found pet bulletin with comments
			erb :profile
		end

		get '/lost' do
		 	#view gallery of local lost animals
		 	erb :"missing"
		end

		get '/lost/new' do 
		 	#form to create a new bulletin for a lost pet
		 	erb :"lost/new"
		end

		post '/lost/new' do
		 	#create a new bulletin for a lost pet
		 	a = params
		 	MissingPet.create!(a)
		 	redirect to '/'
		end

		get '/lost/:id' do
			#return specific lost animal bulletin, and comments
			@info = MissingPet.find(params[:id])
			messages = LostMessage.where(animal_id: params['id'])
			@messages = messages.to_json
			erb :"lost/bulletin"
		end

		get '/found' do
		 	#create a new bulletin for a found pet
		 	erb :found
		end

		post '/found/new' do
		 	#create a new bulletin for a found pet
		 	a = params
		 	FoundPet.create!(a)
		 	redirect to '/'
		end

		get '/found/new' do
		 	#create a new bulletin for a found pet

		 	erb :"found/new"
		end

		get '/found/:id' do
			#return specific found pet bulletin with comments
			FoundPet.find(params[:id])
			erb :"found/bulletin"

		end

		post 'bulletin/:id/message' do
		 	#post new discussion message to a lost/found bulletin
		 	#params: post id, user id
		 end

	end
end