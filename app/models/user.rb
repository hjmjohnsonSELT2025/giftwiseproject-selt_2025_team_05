class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :username
  validates_uniqueness_of :username
  has_many :events
  has_many :event_users
  has_many :joined_events, through: :event_users, source: :event
end