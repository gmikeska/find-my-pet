module FindMyPet
  class FoundMessage < ActiveRecord::Base
    belongs_to :found_pet, foreign_key: 'animal_id'
    belongs_to :user
end
end