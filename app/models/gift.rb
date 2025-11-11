class Gift < ActiveRecord::Base
  belongs_to :user, foreign_key: :recipient_id
end