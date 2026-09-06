class Notification < ApplicationRecord
  belongs_to :user
  validates :action_type, presence: true
  validates :message, presence: true
end
