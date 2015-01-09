require 'net/smtp'

module FindMyPet
	class User < ActiveRecord::Base
		validates :email, presence: true, uniqueness: true
		validates :password, presence: true

		def send_activation ()

			message = <<EMAIL
From: Bring Spot Home! Support <noreply@bringspothome.com>
To: user <gmikeska07@gmail.com>
Subject: Welcome to Bring Spot Home!
EMAIL
			message = message + "Thank you for signing up for Bring Spot Home!\nYour activation code is: #{self.activation}.\n"

			Net::SMTP.start('smtp.sendgrid.net', 25, 'smtp.sendgrid.net',
                'gmikeska', 'rubyjsmakersquare', :plain) do |smtp|
  					smtp.send_message message,
                    'noreply@bringspothome.com',
                    'gmikeska07@gmail.com'
				end

		end
	end
end