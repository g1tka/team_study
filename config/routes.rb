Rails.application.routes.draw do
  # devise_for を使ってデバイスを設定
  devise_for :customers, controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions',
  }

  devise_for :admin, controllers: {
    sessions: 'admin/sessions',
  }

  # 検索のためのルーティング
  get 'search/index'

  # public スコープ内のルーティング定義
  scope module: :public do
    root "homes#top"
    get "/about" => "homes#about"

    get '/customers/my_page', to: 'customers#show'

    get '/customers/information/edit', to: 'customers#edit'
    patch '/customers/information', to: 'customers#update'

    # 検索
    get 'search', to: 'search#index', as: :search

    # 商品のルーティング
    resources :items, only: [:index, :show]

    # 顧客に関するルーティング
    resource :customers do
      get 'unsubscribe' # 退会ページへのルーティング
      patch 'withdraw' # 退会処理のルーティング

      collection do
        get :my_page
      end
    end

    # カートに関するルーティング
    resources :cart_items, only: [:index, :update, :create, :destroy] do
      collection do
        delete :destroy_all
      end
    end

    # 注文に関するルーティング
    resources :orders, only: [:new, :create, :index, :show] do
      collection do
        post :confirm
        get :thanks
      end
    end

    # 住所に関するルーティング
    resources :addresses, only: [:index, :edit, :create, :update, :destroy]

    # ジャンルに関するルーティング
    resources :genres, only: [:show]
  end

  # admin スコープ内のルーティング
  namespace :admin do
    get '/' => 'homes#top'
    resources :items, only: [:index, :new, :create, :show, :edit, :update]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :orders, only: [:show, :update, :index]
    resources :order_details, only: [:update]
  end
end