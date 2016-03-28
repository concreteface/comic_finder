require 'date'

class Wednesday

  def initialize
  end

  def self.date_of_last
    date  = Date.parse('Wednesday')
    delta = date < Date.today ? 0 : 7
    date - delta
  end

  def self.date_of_next
    date  = Date.parse('Wednesday')
    delta = date > Date.today ? 0 : 7
    date + delta
  end
end

date = Wednesday.date_of_next
puts date

