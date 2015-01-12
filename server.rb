require 'sinatra'
	require 'sinatra/reloader'
#require 'rest-client'
require 'json'
require 'bcrypt'
require 'rack-flash'
require 'pry-byebug'
require_relative 'config/environments.rb'
require_relative 'lib/geokitMethods.rb'

module FindMyPet
	class Server < Sinatra::Application
		configure do
		    enable :sessions
		    use Rack::Flash
		  end

		before do
			begin
				if session['user_id']
					@user_id = session['user_id']
					@user = User.find(@user_id)
				end
			rescue ActiveRecord::RecordNotFound
				session.clear
				redirect to '/'
			end
		 end

		get '/' do
			if session['user_id']
				if @user.activation
					erb :"auth/activation"
				else
					@posts = MissingPet.all.as_json
					@posts.each do |p|
						images = LostImage.where(animal_id: p['id'])
						image = images.first
						if image
							p["picurl"] = image["image_url"]
						else 
							p["picurl"] = ""
						end
					end
					@posts = @posts.to_json
					# binding.pry
					erb :index
				end	
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
			params.delete('password')
			if(password == confirm)
				begin
					params['activation'] = (0...8).map { (65 + rand(26)).chr }.join
					params.delete('confirm')
					params['street_address'] = params['address']
					point = GEO.geocode("#{params['street_address']}, #{params['city']}, #{params['state']}")
					params.delete('address')
					if point.success
						params['latitude'] = point.latitude
						params['longitude'] = point.longitude 
						params['email_address'] = params['email']
						params.delete('email')
						a = User.new(params)
						a.password = password
						a.save!
						session['user_id'] = a.id
						a.send_activation
						redirect to "/"
					else
						flash.now[:alert] = "Geocoding Error. Please contact support."
						erb :"auth/signup"
					end
					
				rescue ActiveRecord::RecordInvalid
					flash.now[:alert] = $!.to_s
					erb :"auth/signup"
				end
					
			else
				flash.now[:alert] = "The passwords you entered don't match. Please re-enter and confirm your password."
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
			if(user != nil && user.password == params["password"])

				session['user_id'] = user['id']
				redirect to '/'
			else
				flash.now[:alert] = "Email address not found or password is incorrect. Please try again."
				erb :"auth/signin"
			end
		end

		get '/profile' do
			#return specific found pet bulletin with comments
			erb :profile
		end
		post '/profile' do
			begin
				if params['password'] != ''
					if params['password'] == params['confirm']
						params.delete('confirm')
					else
						flash.now[:alert] = "Password entries don't match."
						erb :profile
					end
				else
					params.delete('password')
					params.delete('confirm')
				end
				params['street_address'] = params['address']
				point = GEO.geocode("#{params['street_address']}, #{params['city']}, #{params['state']}")
				params.delete('address')
				params['email_address'] = params['email']
				params.delete('email')
				if point.success
					params['latitude'] = point.latitude
					params['longitude'] = point.longitude
				else
					flash.now[:alert] = "Geocoding Error. Please contact support."
					erb :profile
				end
				params.each do |param, v|
					@user[param] = v
					end
				@user.save

				flash.now[:success] = "Your profile has been updated!"

				erb :profile
			rescue ActiveRecord::RecordInvalid
				flash.now[:alert] = $!.to_s
				erb :profile
			end
		end

		get '/userinfo' do
			@user = User.find(session['user_id'])		
			@mylostposts = MissingPet.where(user_id: session['user_id'])		
			@myfoundposts = FoundPet.where(user_id: session['user_id'])	
			@myfcomments = FoundMessage.where(user_id: session['user_id'])
			@mylcomments = LostMessage.where(user_id: session['user_id'])
		
			erb :profileview
		end
		get '/lost' do
		 	#view gallery of local lost animals
		 	@bulletins = @user.within_radius(MissingPet).to_json
		 	erb :missing
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
			messages = LostMessage.joins(:user).where(animal_id: params['id'])
			@messages = messages.to_json
			erb :"lost/bulletin"
		end

		get '/found' do
		 	#create a new bulletin for a found pet
		 	bulletins = @user.within_radius(FoundPet)
	 	
		 	bulletins.each{ |b|
		 		if b['name'] == nil 
		 			b['name'] = 'unknown'
		 		end
		 	}
		 	@bulletins = bulletins.to_json
		 	erb :found
		end

		post '/found/new' do
		 	#create a new bulletin for a found pet
		 	a = params
		 	pet = FoundPet.create!(a)
		 	point = GEO.geocode(pet.where_found)
		 	pet.longitude = point.longitude
		 	pet.latitude = point.latitude
		 	pet.save!
		 	@users = GEO.getWithinRadius(50, point.longitude, point.latitude, 'users')
		 	redirect to '/'
		end

		get '/found/new' do
		 	#create a new bulletin for a found pet

		 	erb :"found/new"
		end

		get '/found/:id' do
			#return specific found pet bulletin with comments
			@info = FoundPet.find(params[:id])
			messages = FoundMessage.where(animal_id: params['id']).as_json
			messages.each{|m|
				user = User.find(m['user_id']).as_json
				m["username"] = user["name"]
				puts m
			}
			@messages = messages.to_json
			erb :"found/bulletin"

		end

		post '/found/:id/message' do
		 	#post new discussion message to a lost/found bulletin
		 	#params: post id, user id
			message = {}
		 	message['message'] = params['message']
		 	message['animal_id'] = params['id']
		 	message['user_id'] = session['user_id']
		 	FoundMessage.create!(message)
		 	redirect to '/found/'+ params['id']
		 end

		post '/lost/:id/message' do
		 	#post new discussion message to a lost/found bulletin
		 	#params: post id, user id
		 	message = {}
		 	message['message'] = params['message']
		 	message['animal_id'] = params['id']
		 	message['user_id'] = session['user_id']
		 	LostMessage.create!(message)
		 	redirect to '/lost/'+ params['id']
		end

	end
end