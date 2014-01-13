class DropMyEmail::Base < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "dme_#{Rails.env}"
  
  def readonly?
    return true
  end
    
  def before_destroy
    raise ActiveRecord::ReadOnlyRecord
  end
end
