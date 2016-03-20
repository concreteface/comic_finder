class RemoveDateFromIssues < ActiveRecord::Migration
  def change
    remove_column :issues, :cover_date, :string
  end
end
