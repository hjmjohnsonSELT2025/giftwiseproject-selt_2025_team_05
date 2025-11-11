class User < ActiveRecord::Base
  has_many :events
  has_many :event_users
  has_many :joined_events, through: :event_users, source: :event
  has_many :preferences, dependent: :destroy
end