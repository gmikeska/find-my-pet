class Changeactivation < ActiveRecord::Migration
  def change
    change_table :users do |t|
    	change_column :users, :activation, :string    	
    end
  end
end
