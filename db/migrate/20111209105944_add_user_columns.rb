class AddUserColumns < ActiveRecord::Migration
  def change
    add_column :users, :firstName, :string
    add_column :users, :lastName, :string
    add_column :users, :username, :string
    add_column :users, :default_list, :integer
    
    add_index :users, :default_list
  end
end
