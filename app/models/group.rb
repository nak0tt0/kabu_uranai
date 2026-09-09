class Group < ApplicationRecord
  belongs_to :user
  has_many :stocks, dependent: :nullify

  validates :name, presence: true
end
