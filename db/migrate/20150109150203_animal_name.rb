class AnimalName < ActiveRecord::Migration
  def change
    change_table :found do |t|
    	t.column :name, :string
    end
    change_table :lost do |t|
    	t.column :name, :string
    	end    	    	
  end
end
