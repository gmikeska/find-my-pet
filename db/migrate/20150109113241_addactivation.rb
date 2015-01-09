class Addactivation < ActiveRecord::Migration
  def change
    change_table :users do |t|
    	t.column :activation, :integer    	
    end
  end
end
