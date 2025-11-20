class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :events
  has_many :event_users
  has_many :joined_events, through: :event_users, source: :event
  has_many :preferences, dependent: :destroy

  scope :search_by_name_or_email, ->(query) {
    return all if query.blank?

    term = "%#{query.downcase}%"

    where(
      "lower(email) LIKE ? OR lower(first_name) LIKE ? OR lower(last_name) LIKE ?",
      term, term, term
    )
  }
end
