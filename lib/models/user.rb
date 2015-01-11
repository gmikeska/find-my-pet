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

			Net::SMTP.start('smtp.sendgrid.net', 25, 'smtp.sendgrid.net',
                'gmikeska', 'rubyjsmakersquare', :plain) do |smtp|
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
			message = "Dear #{self.name},\nThank you for signing up for Bring Spot Home!\n\nYour activation code is: #{self.activation}\n\nYou can click on the following link to activate your account:\n http://localhost:4567/activation?activation=#{self.activation}\n\n Thanks!\nThe BSH Team!"
			self.send_email(subject, message)
		end
		def within_radius(tablename)
			GEO.getWithinRadius(self.radius, self.longitude, self.latitude, tablename)

		end
		def local_alert (type, params)
			subject = "New '#{type}' alert in your area - Bring Spot Home"
			message = "Dear #{self.name},\nThere is a new #{type} alert in your area.\nHere are the details:\n"
			params.keys.each do |k|
				message = message+k+":"+params[k]+"\n"
			end
			self.send_email(subject, message)
		end
	end
end