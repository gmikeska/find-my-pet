require 'net/smtp'

module FindMyPet
	class User < ActiveRecord::Base
		validates :email_address, presence: true, uniqueness: true
		validates :password, presence: true

		def send_activation ()
			user_from = "noreply@bringspothome.com"  
			user_to = self.email_address  
			the_email = "From: noreply@bringspothome.com\nSubject: Welcome to Bring Spot Home!\n\nThank you for signing up for Bring Spot Home!\n\nYour activation code is: #{self.activation}.\n\n"
			# handling exceptions  

			Net::SMTP.start('smtp.sendgrid.net', 25, 'smtp.sendgrid.net',
                'gmikeska', 'rubyjsmakersquare', :plain) do |smtp|
  					smtp.send_message the_email,
                    user_from,
                    user_to
				end

		end
	end
end