module FindMyPet
	class FoundPet < ActiveRecord::Base
		belongs_to :user #User relationship would be the user that found the animal.
	end
end