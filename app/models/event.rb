class Event < ApplicationRecord
  belongs_to :user

  has_many :event_users
  has_many :participants, through: :event_users, source: :user

  validates :name, presence: true
  validates :name, uniqueness: {scope: :user}
end
