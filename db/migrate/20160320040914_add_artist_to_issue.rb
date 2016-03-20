class AddArtistToIssue < ActiveRecord::Migration
  def change
  	add_column :issues, :artist, :string
  end
end
