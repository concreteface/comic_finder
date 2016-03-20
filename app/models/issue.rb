class Issue < ActiveRecord::Base
  validates :title, presence: true
end
