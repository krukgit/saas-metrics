module DropMyEmail
  class Account < DropMyEmail::Base
    belongs_to :user, validate: true

    has_many :backups
    has_many :migrates
    has_many :restores
    default_scope { where(flg_deleted: false) }
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id                        :integer          not null, primary key
#  user_id                   :integer          not null
#  host                      :string(255)      not null
#  protocol                  :integer          default(1), not null
#  start_tls                 :boolean          default(FALSE), not null
#  ssl                       :boolean          default(FALSE), not null
#  port                      :integer          not null
#  mboxes                    :string(255)      default(""), not null
#  schedule_type             :string(255)      default("2"), not null
#  week_day                  :integer
#  month_day                 :integer
#  last_backup               :datetime
#  msg_count                 :integer          default(0), not null
#  storage                   :integer          default(0), not null
#  created_at                :datetime         not null
#  updated_at                :datetime
#  flg_deleted               :boolean          default(FALSE), not null
#  encrypted_password        :binary
#  encrypted_email           :binary
#  username                  :string(255)
#  google_oauth_token        :string(255)
#  google_oauth_token_secret :string(255)
#  att_count                 :integer          default(0), not null
#  data_deleted              :boolean
#
# Indexes
#
#  idx_created_at  (created_at)
#  idx_host        (host)
#  idx_user_id     (user_id)
#
