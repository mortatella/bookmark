class CreateManifests < ActiveRecord::Migration
  def change
    create_table :manifests do |t|
      t.integer :bookmark_id
      t.integer :list_id
      t.timestamps
    end
    
    add_index :manifests, :bookmark_id
    add_index :manifests, :list_id
  end
end
