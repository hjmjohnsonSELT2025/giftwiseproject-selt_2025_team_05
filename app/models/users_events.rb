class Users_Events < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
end