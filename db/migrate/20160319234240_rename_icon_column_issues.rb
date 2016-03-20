class RenameIconColumnIssues < ActiveRecord::Migration
  def change
    rename_column :issues, :icon_url, :image_url
  end
end
