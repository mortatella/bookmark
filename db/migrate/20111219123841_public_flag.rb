class PublicFlag < ActiveRecord::Migration
  def change
	change_column :lists, :public, :boolean, :default => false
  end

end
