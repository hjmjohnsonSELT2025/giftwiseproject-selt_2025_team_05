class Preference < ApplicationRecord
  belongs_to :user
  belongs_to :giver, class_name: "User", optional: true
  belongs_to :event, optional: true
end
