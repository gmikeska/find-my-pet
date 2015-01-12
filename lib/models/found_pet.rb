module FindMyPet
	class FoundPet < ActiveRecord::Base
    self.table_name = 'found'
		belongs_to :user #User relationship would be the user that found the animal.
		def local_users
			GEO.getWithinRadius(50, self.longitude, self.latitude, User)
		end
	end
end