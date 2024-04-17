Rails.application.routes.draw do
  devise_for :users
  root to: 'mtweets#index'
  resources :mtweets do
    resources :comments, only: :create
    collection do
      get 'search'
    end
  end
  resources :users, only: :show
  #コメント、メインで修正、コミットなしで、ブランチを作成し「Leave my changes on master」を選択すると、この説明が消えることを確認する
  #コメント、メインで修正、コミットした後に、ブランチを作成し「Leave my changes on master」を選択すればこの説明が消えないことを確認する
