class CreateName < ActiveRecord::Migration
  def change
     def change
    change_table :users do |t|
    	t.column :name, :string
    	end    	
    end
  end
end
