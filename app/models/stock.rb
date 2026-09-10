class Stock < ApplicationRecord
  # Rails 8.1 仕様の enum 構文 (第一引数にシンボルを指定)
  enum(:status, { holding: 0, pending: 1, sold: 2 }, default: :holding)

  belongs_to :user
  belongs_to :group, optional: true
  has_one :post_mortem, dependent: :destroy
  has_many :stock_tags, dependent: :destroy
  has_many :tags, through: :stock_tags

  validates :ticker_symbol, presence: true
  validates :name, presence: true
  validates :purchase_motivation, presence: true
  validates :exit_scenario, presence: true
end
