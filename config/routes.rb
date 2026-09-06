Rails.application.routes.draw do

  root "homes#top"
  get "about", to: "homes#about"
  get "users/show"
  get "registrations/new"
  get "registrations/create"

  # 新規会員登録
  get  "signup", to: "registrations#new"
  post "signup", to: "registrations#create"

  # マイページ（登録完了後のリダイレクト先として一旦定義）
  get "mypage", to: "users#show"

  get "up" => "rails/health#show", as: :rails_health_check

end
