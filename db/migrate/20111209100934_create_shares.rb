class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.boolean :write
      t.integer :list_id
      t.integer :bookmark_id
      t.timestamps
    end
    
    add_index :shares, :list_id
    add_index :shares, :bookmark_id
  end
end
