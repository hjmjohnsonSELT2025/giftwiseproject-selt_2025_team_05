class Friendship < ApplicationRecord
  belongs_to :user                          # sender
  belongs_to :friend, class_name: "User"    # receiver

  enum status: {
    pending:  "pending",
    accepted: "accepted",
    declined: "declined",
    blocked:  "blocked"
  }, _prefix: :status

  # https://guides.rubyonrails.org/active_record_querying.html#scopes
  scope :pending_outgoing, ->(user) { where(user_id: user.id, status: "pending") }
  scope :pending_incoming, ->(user) { where(friend_id: user.id, status: "pending") }

  # friendships where either side is the user AND accepted
  scope :accepted_for, ->(user) {
    where(status: "accepted")
      .where("user_id = ? OR friend_id = ?", user.id, user.id)
  }


  validates :user_id, uniqueness: { scope: :friend_id }
  validate :cannot_friend_self

  private

  def cannot_friend_self
    errors.add(:friend_id, "can't be the same as user") if user_id == friend_id
  end
end
