require 'net/smtp'

module FindMyPet
	class User < ActiveRecord::Base
		validates :email_address, presence: true, uniqueness: true
		validates :password, presence: true
		 include BCrypt
		def send_email (subject, message)
			user_from = "noreply@bringspothome.com"  
			user_to = self.email_address  
			
			the_email = "From: noreply@bringspothome.com\nSubject: #{subject}\n\n#{message}\n\n"
			# handling exceptions  
			puts "user: #{ENV['sendgrid_user']} password: #{ENV['sendgrid_pw']}"
			Net::SMTP.start('smtp.sendgrid.net', 25, 'smtp.sendgrid.net',
                ENV['SENDGRIDUSER'], ENV['SENDGRIDPW'], :plain) do |smtp|
  					smtp.send_message the_email,
                    user_from,
                    user_to
				end
		end
		def password
    		@password ||= Password.new(password_hash)
 		end
		def password=(new_password)
    		@password = Password.create(new_password)
    		self.password_hash = @password
  		end
		def send_activation ()
			subject = "Welcome to Bring Spot Home!"
			message = "Dear #{self.name},\nThank you for signing up for Bring Spot Home!\n\nYour activation code is: #{self.activation}\n\nYou can click on the following link to activate your account:\n http://find-my-pet.herokuapp.com/activation?activation=#{self.activation}\n\n Thanks!\nThe BSH Team!"
			self.send_email(subject, message)
		end
		def within_radius(tablename)
			GEO.getWithinRadius(self.radius, self.longitude, self.latitude, tablename)

		end
		def distance_to(target)
			a = Geokit::LatLng.new(self.longitude, self.latitude)
			b = Geokit::LatLng.new(target.longitude, target.latitude)
			distance = a.distance_to(b)

		end
		def local_alert (type, params)
			drop = ['id', 'user_id', 'longitude', 'latitude', 'is_lost', 'other', 'created']
			label = {}
			label['where_lost'] = 'Location'
			label['animal_gender'] = 'Gender'
			label['animal_type'] = 'Species'
			label['animal_breed'] = 'Breed'
			subject = "New '#{type}' alert in your area - Bring Spot Home"
			message = "Dear #{self.name},\nThere is a new #{type} alert in your area.\nHere are the details:\n"
			params.keys.each do |k|
				if(!drop.include?(k) && !label[k])
					key = k.gsub('_',' ')
					keys = key.split(' ')
					keys.each do |w|
						w.capitalize!
					end
					key = keys.join(' ')
					message = "#{message} #{key}: #{params[k]}\n"
				elsif(label[k])
					message = "#{message} #{label[k]}: #{params[k]}\n"
				end
			end
			self.send_email(subject, message)
		end
	end
end