class Friendship < ApplicationRecord
  belongs_to :user                          # sender
  belongs_to :friend, class_name: "User"    # receiver

  enum status: {
    pending:  "pending",
    accepted: "accepted",
    declined: "declined",
    blocked:  "blocked"
  }, _prefix: :status

  validates :user_id, uniqueness: { scope: :friend_id }
  validate :cannot_friend_self

  private

  def cannot_friend_self
    errors.add(:friend_id, "can't be the same as user") if user_id == friend_id
  end
end
