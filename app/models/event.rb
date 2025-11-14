class Event < ApplicationRecord
  belongs_to :user

  has_many :event_users
  has_many :participants, through: :event_users, source: :user

  validates :name, presence: true,
            uniqueness: { scope: :user_id, case_sensitive: false,
                          message: "has already been used for one of your events" }
end