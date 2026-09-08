class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  # 銘柄一覧
  def index
    @stocks = current_user.stocks.includes(:group, :tags)
  end

  # 銘柄詳細
  def show
  end

  # 新規登録画面
  def new
    @stock = current_user.stocks.build
  end

  # 登録処理
  def create
    @stock = current_user.stocks.build(stock_params)

    if @stock.save
      redirect_to stocks_path, notice: "銘柄を登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 編集画面
  def edit
  end

  # 更新処理
  def update
    if @stock.update(stock_params)
      redirect_to stocks_path, notice: "銘柄情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除処理
  def destroy
    @stock.destroy
    redirect_to stocks_path, notice: "銘柄を削除しました。", status: :see_other
  end

  private

  def set_stock
    @stock = current_user.stocks.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(
      :ticker_symbol,
      :name,
      :status,
      :shares,
      :acquisition_price,
      :purchase_motivation,
      :exit_scenario,
      :group_id,
      tag_ids: []
    )
  end
end
