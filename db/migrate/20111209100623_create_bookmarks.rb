class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :url
      t.string :title
      t.string :description
      t.timestamps
    end
  end
end
