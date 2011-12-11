class CreateBookmarksTags < ActiveRecord::Migration
  def change
    create_table :bookmarks_tags do |t|
      t.integer :bookmark_id
      t.integer :tag_id
      t.timestamps
      
      
    end
    
    add_index :bookmarks_tags, :bookmark_id
    add_index :bookmarks_tags, :tag_id
  end
end

