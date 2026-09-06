class Stock < ApplicationRecord
  enum(:status, { holding: 0, pending: 1, sold: 2 }, default: :holding)

  belongs_to :user
  belongs_to :group, optional: true
  has_many :stock_tags, dependent: :destroy
  has_many :tags, through: :stock_tags

  validates :ticker_symbol, presence: true
  validates :name, presence: true
  validates :purchase_motivation, presence: true
  validates :exit_scenario, presence: true
end

