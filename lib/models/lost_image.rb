module FindMyPet
	class LostImage < ActiveRecord::Base
		belongs_to :missing_pet, foreign_key: 'animal_id'
	end
end