class PasswordHash < ActiveRecord::Migration
  def change
   	change_table :users do |t|
    	t.column :password_hash, :string    	
    end
    remove_column :users, :password, :string
  end
end
