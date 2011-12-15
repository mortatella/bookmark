class ChangeTags < ActiveRecord::Migration
  def change
    create_table :tags_users do |t|
      t.integer :tag_id
      t.integer :user_id
    end
    
    add_index :tags_users, :tag_id
    add_index :tags_users, :user_id
    
    remove_column :tags, :user_id
    
  end
end
