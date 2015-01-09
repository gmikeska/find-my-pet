module FindMyPet
	class MissingPet < ActiveRecord::Base
    self.table_name = "lost"
		belongs_to :user #User relationship would be the owner that reported the animal lost.
	 has_many :lost_images, foreign_key: 'animal_id'
   has_many :lost_messages
  end
end