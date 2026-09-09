class PostMortemsController < ApplicationController
  before_action :set_post_mortem, only: [:show, :edit, :update, :destroy]
  before_action :set_stock, only: [:new, :create]

  # 振り返り（事後検証）一覧画面 (/post_mortems)
  def index
    @post_mortems = current_user.post_mortems.includes(:stock).order(created_at: :desc)
  end

  # 振り返り詳細画面 (/post_mortems/:id)
  def show
  end

  # 新規作成画面 (/stocks/:stock_id/post_mortems/new)
  def new
    @post_mortem = @stock.build_post_mortem
  end

  # 登録処理 (/stocks/:stock_id/post_mortems)
  def create
    @post_mortem = @stock.build_post_mortem(post_mortem_params)
    @post_mortem.user = current_user

    if @post_mortem.save
      redirect_to post_mortem_path(@post_mortem), notice: "振り返りノートを記録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 編集画面 (/post_mortems/:id/edit)
  def edit
  end

  # 更新処理 (/post_mortems/:id)
  def update
    if @post_mortem.update(post_mortem_params)
      redirect_to post_mortem_path(@post_mortem), notice: "振り返りノートを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除処理 (/post_mortems/:id)
  def destroy
    @post_mortem.destroy
    redirect_to post_mortems_path, notice: "振り返りノートを削除しました。", status: :see_other
  end

  private

  def set_post_mortem
    @post_mortem = current_user.post_mortems.find(params[:id])
  end

  def set_stock
    @stock = current_user.stocks.find(params[:stock_id])
  end

  def post_mortem_params
    params.require(:post_mortem).permit(
      :reason_for_sale,
      :actual_return_percentage,
      :holding_period,
      :ai_gap_analysis,
      :lessons_learned
    )
  end
end
