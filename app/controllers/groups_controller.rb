class GroupsController < ApplicationController
  before_action :set_group, only: [:edit, :update, :destroy]

  # 一覧表示・新規作成フォーム兼用画面 (/groups)
  def index
    @groups = current_user.groups.order(created_at: :desc)
    @group = current_user.groups.build
  end

  # 登録処理
  def create
    @group = current_user.groups.build(group_params)
    if @group.save
      redirect_to groups_path, notice: "グループ「#{@group.name}」を作成しました。"
    else
      @groups = current_user.groups.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  # 編集画面 (/groups/:id/edit)
  def edit
  end

  # 更新処理
  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "グループ名を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除処理
  def destroy
    @group.destroy
    redirect_to groups_path, notice: "グループを削除しました。", status: :see_other
  end

  private

  def set_group
    @group = current_user.groups.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
