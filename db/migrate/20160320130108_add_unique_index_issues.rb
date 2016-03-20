class AddUniqueIndexIssues < ActiveRecord::Migration
  def change
    add_index :issues, :title, unique: true
  end
end
