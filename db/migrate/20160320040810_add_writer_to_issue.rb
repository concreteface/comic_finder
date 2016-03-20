class AddWriterToIssue < ActiveRecord::Migration
  def change
  	add_column :issues, :writers, :string
  end
end
