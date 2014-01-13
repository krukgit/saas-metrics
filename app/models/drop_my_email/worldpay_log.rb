# The WorldpayLog class is a raw log of all the ipns we receive from Worldpay
# It can contain completely invalid entries, like ipns for invalid users, or
# rejected payments. Ideally it has everything that reaches our IPN handler
# for auditing purposes.
# The Worldpay log has some attributes separated into columns for easier querying.
class WorldpayLog < ActiveRecord::Base

  # Prevent creation of new records and modification to existing records
  def readonly?
    return true
  end

  # Prevent objects from being destroyed
  def before_destroy
    raise ActiveRecord::ReadOnlyRecord
  end
end
