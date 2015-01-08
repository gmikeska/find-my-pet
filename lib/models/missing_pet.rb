module FindMyPet
	class MissingPet < ActiveRecord::Base
		belongs_to :user #User relationship would be the owner that reported the animal lost.
	end
end