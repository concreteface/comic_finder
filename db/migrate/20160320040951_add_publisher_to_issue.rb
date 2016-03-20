class AddPublisherToIssue < ActiveRecord::Migration
  def change
  	add_column :issues, :publisher, :string
  end
end
