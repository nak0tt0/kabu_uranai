Rails.application.routes.draw do
  # ルートおよび静的ページ
  root "homes#top"
  get "about", to: "homes#about"

  # 新規会員登録
  get  "signup", to: "registrations#new"
  post "signup", to: "registrations#create"

  # 一般ユーザー用 ログイン / ログアウト / ゲストログイン
  get    "login",        to: "sessions#new"
  post   "login",        to: "sessions#create"
  delete "logout",       to: "sessions#destroy"
  post   "guest_login", to: "sessions#guest_login"

  # マイページ
  get "mypage", to: "users#show"

  # 銘柄管理機能（CRUD）
  resources :stocks

  # 管理者専用エリア (/admin/...)
  namespace :admin do
    get    "login",  to: "sessions#new"
    post   "login",  to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    get "dashboard", to: "dashboards#show"
    resources :users, only: [:index, :show, :destroy]
  end

  # Rails標準のヘルスチェック用
  get "up" => "rails/health#show", as: :rails_health_check
end
