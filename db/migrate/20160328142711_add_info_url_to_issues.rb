class AddInfoUrlToIssues < ActiveRecord::Migration
  def change
  	add_column :issues, :info_url, :string
  end
end
