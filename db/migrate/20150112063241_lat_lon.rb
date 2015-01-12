class LatLon < ActiveRecord::Migration
  def change
   	change_table :lost do |t|
    	t.column :latitude, :float
    	t.column :longitude, :float  	
    end
    change_table :found do |t|
    	t.column :latitude, :float
    	t.column :longitude, :float  	
    end
    remove_column :lost, :where_latitude, :float
    remove_column :lost, :where_longitude, :float
    remove_column :found, :where_latitude, :float
    remove_column :found, :where_longitude, :float
  end
end
