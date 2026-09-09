class PlantGrowth < ApplicationRecord
  belongs_to :user

  validates :level, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :experience_point, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :fruit_count, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # 次のレベルに必要な経験値 (拡張用)
  def next_level_exp
    level * 100
  end
end
