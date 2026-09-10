class Notification < ApplicationRecord
  belongs_to :user

  scope :unread, -> { where(read_status: false) }
  scope :recent, -> { order(created_at: :desc) }

  def mark_as_read!
    update!(read_status: true)
  end
end
