class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  def index
    @stocks = current_user.stocks.order(created_at: :desc)
  end

  def show
  end

  def new
    @stock = current_user.stocks.build
  end

  def create
    @stock = current_user.stocks.build(stock_params)
    if @stock.save
      redirect_to stocks_path, notice: "銘柄を登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @stock.update(stock_params)
      redirect_to stock_path(@stock), notice: "銘柄情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stock.destroy
    redirect_to stocks_path, notice: "銘柄を削除しました。"
  end

  # CSV取り込み処理
  def import
    if params[:file].present?
      count = Stock.import_csv(params[:file], current_user)
      redirect_to stocks_path, notice: "#{count}件の銘柄データをCSVから取り込みました。"
    else
      redirect_to new_stock_path, alert: "CSVファイルを選択してください。"
    end
  end

  private

  def set_stock
    @stock = current_user.stocks.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:ticker_symbol, :name, :shares, :acquisition_price, :purchase_motivation, :exit_scenario, :group_id, :status)
  end
end
