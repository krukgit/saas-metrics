# Users are the actual site users, they can be authenticated and have several
# accounts to be backed up.
require 'ipaddr'

module DropMyEmail
  class User < DropMyEmail::Base
    has_many :accounts
    has_one :country
    GMO_REFERRAL_CODE = 'gmocloud'
    TIME_FRAMES = %w(today yesterday week month all)
    scope :gmo_users, -> { where(referral_code: GMO_REFERRAL_CODE) }
    scope :today, -> { where("created_at > ?", 1.day.ago) }
    scope :yesterday, -> { where("created_at > ?", 2.day.ago) } 
    scope :week, -> { where("created_at > ?", 7.days.ago) }
    scope :month, -> { where("created_at > ?", 1.month.ago) }

    def active?
      self.accounts.present?
    end
    
    def on_trial?
      DropMyEmail::BillinglySubscription.where("customer_id = ? AND is_trial_expiring_on > ? AND unsubscribed_on = ?", self.billingly_customer_id, Time.now, nil).present?
    end
    
    def on_pro?
      DropMyEmail::BillinglySubscription.where("customer_id = ? AND description != ? AND unsubscribed_on = ?", self.billingly_customer_id, 'Free Trial', nil).present?
    end
    
    class << self
      TIME_FRAMES.each do |time_frame|
        define_method("#{time_frame}_total_gmo_users") do
          if time_frame == 'all'
            User.gmo_users.count
          else
            User.gmo_users.send(time_frame).count
          end
        end
        
        define_method("#{time_frame}_active_users") do
          if time_frame == 'all'
            User.gmo_users.select(&:active?).count
          else
            User.gmo_users.send(time_frame).select(&:active?).count
          end
        end
        
        define_method("#{time_frame}_trial_users") do
          if time_frame == 'all'
            User.gmo_users.select(&:on_trial?).count
          else
            User.gmo_users.send(time_frame).select(&:on_trial?).count
          end
        end
        
        define_method("#{time_frame}_pro_users") do
          if time_frame == 'all'
            User.gmo_users.select(&:on_pro?).count
          else
            User.gmo_users.send(time_frame).select(&:on_pro?).count
          end
        end
        
        define_method("#{time_frame}_accounts") do
          if time_frame == 'all'
            User.gmo_users.map(&:accounts).flatten.count
          else
            User.gmo_users.send(time_frame).map(&:accounts).flatten.count
          end
        end

        define_method("message_count_#{time_frame}") do
          if time_frame == 'all'
            User.gmo_users.map(&:accounts).flatten.map(&:backups).flatten.map(&:messages).compact.reduce(:+) || 0
          else
            User.gmo_users.send(time_frame).map(&:accounts).flatten.map(&:backups).flatten.map(&:messages).compact.reduce(:+) || 0
          end
        end

        define_method("#{time_frame}_migrates") do
          if time_frame == 'all'
            User.gmo_users.map(&:accounts).flatten.map(&:migrates).flatten.size
          else
            User.gmo_users.send(time_frame).map(&:accounts).flatten.map(&:migrates).flatten.size
          end
        end

        define_method("#{time_frame}_restores") do
          if time_frame == 'all'
            User.gmo_users.map(&:accounts).flatten.map(&:restores).flatten.size
          else
            User.gmo_users.send(time_frame).map(&:accounts).flatten.map(&:restores).flatten.size
          end
        end

      end # TIME_FRAMES
    end # self
  end
end
