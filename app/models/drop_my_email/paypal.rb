module DropMyEmail
  class Paypal < DropMyEmail::Base
    self.primary_key = :paypal_id
    self.table_name = :paypal
    belongs_to :user
  end
end
  
# == Schema Information
#
# Table name: paypal
#
#  paypal_id       :integer          not null, primary key
#  user_id         :integer          not null
#  plan_id         :integer          not null
#  insert_date     :datetime         not null
#  txn_id          :string(255)      not null
#  payment_gross   :float(11)        not null
#  payment_fee     :float(11)        not null
#  handling_amount :float(11)        not null
#  payment_status  :string(50)       not null
#  pending_reason  :string(255)      not null
#  payer_email     :string(255)      not null
#  payment_date    :string(255)      not null
#  pg_response_txt :text(255)        default(""), not null
#  flg_deleted     :boolean          default(FALSE), not null
#  user_payment_id :integer
#

