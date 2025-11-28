class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events
  has_many :event_users
  has_many :joined_events, through: :event_users, source: :event
  has_many :preferences, dependent: :destroy

  # Friend requests the user has SENT
  has_many :sent_friendships, class_name: "Friendship", foreign_key: :user_id, dependent: :destroy
  # Friend requests the user has RECEIVED
  has_many :received_friendships, class_name: "Friendship", foreign_key: :friend_id, dependent: :destroy
  # Accepted friendships initiated by the user
  has_many :accepted_friendships, -> { where(status: "accepted") }, class_name: "Friendship", foreign_key: :user_id
  has_many :friends, through: :accepted_friendships, source: :friend

  def all_friends
    Friendship.accepted_for(self).map do |friend|
      friend.user_id == id ? friend.friend : friend.user
    end
  end


  scope :search_by_name_or_email, ->(query) {
    return all if query.blank?

    term = "%#{query.downcase}%"

    where(
      "lower(email) LIKE ? OR lower(first_name) LIKE ? OR lower(last_name) LIKE ?",
      term, term, term
    )
  }
end
