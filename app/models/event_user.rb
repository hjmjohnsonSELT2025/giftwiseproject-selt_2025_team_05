class EventUser < ApplicationRecord
  belongs_to :event
  belongs_to :user

  enum status: {
    invited: 0,
    joined: 1,
    declined: 2,
    left: 3
  }, _default: :invited

  validates :status, presence: true
end
