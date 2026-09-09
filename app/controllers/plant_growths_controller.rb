class PlantGrowthsController < ApplicationController
  before_action :set_plant_growth

  # 木の成長・確認画面 (/plant_growth)
  def show
  end

  # 「実」を収穫してカウントを増やす処理 (/plant_growth/harvest)
  def harvest
    if @plant_growth.experience_point >= 50
      @plant_growth.increment!(:fruit_count)
      @plant_growth.decrement!(:experience_point, 50)
      redirect_to plant_growth_path, notice: "実を1つ収穫しました！"
    else
      redirect_to plant_growth_path, alert: "収穫に必要な経験値（50 EXP）が不足しています。"
    end
  end

  private

  def set_plant_growth
    # 初回アクセス時に育成データがなければ自動生成
    @plant_growth = current_user.plant_growth || current_user.create_plant_growth!
  end
end
