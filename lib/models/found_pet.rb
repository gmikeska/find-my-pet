module FindMyPet
	class FoundPet < ActiveRecord::Base
    self.table_name = 'found'
		belongs_to :user #User relationship would be the user that found the animal.
	  has_many :found_images, foreign_key: 'animal_id'
    has_many :found_messages
  	def local_users
			GEO.getWithinRadius(self.radius, self.longitude, self.latitude, "users")
		end
	end
end