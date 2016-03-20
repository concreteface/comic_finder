class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :title, null: false, unique: true
      t.date :cover_date
      t.string :icon_url
    end
  end
end
