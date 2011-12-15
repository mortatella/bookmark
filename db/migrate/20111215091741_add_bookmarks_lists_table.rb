class AddBookmarksListsTable < ActiveRecord::Migration
  def change
    create_table :bookmarks_lists do |t|
      t.integer :bookmark_id
      t.integer :list_id
      t.timestamps
    end
    
    add_index :bookmarks_lists, :bookmark_id
    add_index :bookmarks_lists, :list_id
  end
end
