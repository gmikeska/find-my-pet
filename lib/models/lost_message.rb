module FindMyPet
	class LostMessage < ActiveRecord::Base
    belongs_to :missing_pet, foreign_key: 'animal_id'
	class
class