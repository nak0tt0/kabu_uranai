class User < ApplicationRecord
  has_secure_password

  enum(:role, { general: 0, admin: 1 }, default: :general)

  has_many :stocks, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
end

