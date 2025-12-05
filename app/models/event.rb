class Event < ApplicationRecord
  belongs_to :user

  has_many :event_users
  has_many :participants, through: :event_users, source: :user

  enum event_type: {
    others: 0,
    family: 1,
    business: 2,
    friend: 3
  }

  validates :name, presence: true,
            uniqueness: { scope: :user_id, case_sensitive: false,
                          message: "has already been used for one of your events" }
  validate :date_cannot_be_in_the_past, on: :create

  private

  def date_cannot_be_in_the_past
    if date.present? && date < Time.current
      errors.add(:date, "can't be in the past")
    end
  end
end
