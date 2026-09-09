class TagsController < ApplicationController
  before_action :set_tag, only: [:edit, :update, :destroy]

  # 一覧表示・新規作成フォーム兼用画面 (/tags)
  def index
    @tags = Tag.order(created_at: :desc)
    @tag = Tag.new
  end

  # 登録処理
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to tags_path, notice: "タグ「#{@tag.name}」を作成しました。"
    else
      @tags = Tag.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  # 編集画面 (/tags/:id/edit)
  def edit
  end

  # 更新処理
  def update
    if @tag.update(tag_params)
      redirect_to tags_path, notice: "タグ名を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除処理
  def destroy
    @tag.destroy
    redirect_to tags_path, notice: "タグを削除しました。", status: :see_other
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
