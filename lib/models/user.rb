require 'net/smtp'

module FindMyPet
	class User < ActiveRecord::Base
		validates :email, presence: true, uniqueness: true
		validates :password, presence: true

		def send_activation ()

			message = "From: Bring Spot Home! Support <noreply@bringspothome.com>"
			message = message +"To: user <#{self.email}>\nSubject: Welcome to Bring Spot Home!\n"

			message = message + "Thank you for signing up for Bring Spot Home!\nYour activation code is: #{self.activation}.\n"

			Net::SMTP.start('smtp.sendgrid.net', 25, 'smtp.sendgrid.net',
                'gmikeska', 'rubyjsmakersquare', :plain) do |smtp|
  					smtp.send_message message,
                    'noreply@bringspothome.com',
                    self.email
				end

		end
	end
end