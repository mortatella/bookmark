class RenameBookmarkIdInSharesTable < ActiveRecord::Migration
  def change
    rename_column :shares, :bookmark_id, :user_id
  end
end
