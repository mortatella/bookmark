class RenameDefaultListColumn < ActiveRecord::Migration
  def change
    rename_column :users, 'default_list', 'default_list_id'
  end
end
