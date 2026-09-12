Rails.application.routes.draw do
  # ==========================================
  # 1. 未ログイン時（パブリック領域）
  # ==========================================
  root "homes#top"
  get "about", to: "homes#about"

  # 新規会員登録
  get  "signup", to: "registrations#new"
  post "signup", to: "registrations#create"

  # ログイン / ログアウト / ゲストログイン
  get    "login",       to: "sessions#new"
  post   "login",       to: "sessions#create"
  delete "logout",      to: "sessions#destroy"
  post   "guest_login", to: "sessions#guest_login"

  # ==========================================
  # 2. ログイン後専用（ユーザーエリア）
  # ==========================================
  # マイページ
  get "mypage", to: "users#show"

  # プロフィール編集・更新・退会 (単数形 resource)
  resource :user, only: [:edit, :update, :destroy]

  # 保有/保留 銘柄管理（CRUD）& CSVインポート
  resources :stocks do
    collection do
      post :import
    end
    # 銘柄ごとの振り返り（事後検証）新規作成・保存（ネスト）
    resources :post_mortems, only: [:new, :create]
  end

  # 振り返り（事後検証）一覧・詳細
  resources :post_mortems, only: [:index, :show]

  # グループ（ジャンル・フォルダ管理）
  resources :groups

  # タグ管理
  resources :tags

  # 通知機能
  resources :notifications, only: [:index] do
    member do
      patch :read # 特定通知の既読化
    end
    collection do
      patch :read_all # 一括既読化
    end
  end

  # ゲーミフィケーション（木の育成機能：単数リソース）
  resource :plant_growth, only: [:show] do
    post :harvest # 「実」の収穫処理
  end

  # ==========================================
  # 3. 管理者エリア (/admin/...)
  # ==========================================
  namespace :admin do
    get    "login",  to: "sessions#new"
    post   "login",  to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    get "dashboard", to: "dashboards#show"
    resources :users, only: [:index, :show, :destroy]
    resource  :profile, only: [:edit, :update]
  end

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check
end
