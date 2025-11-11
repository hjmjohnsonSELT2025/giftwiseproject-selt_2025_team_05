class User < ActiveRecord::Base
  has_many :preferences
  has_many :events
  has_many :users_events
  has_many :friendships
  has_many :friends, through: :friendships, source: :friend
  has_many :gifts, class_name: 'Gift', foreign_key: :recipient_id
end