module Validator
  def validator(input)
    begin
      @date = Date.parse(input)
    rescue
      false
    else true
    end
  end
end
