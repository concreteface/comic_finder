class AddDateToIssues < ActiveRecord::Migration
  def change
  	add_column :issues, :release_date, :date
  end
end
