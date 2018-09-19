Rails.application.routes.draw do
  # namespace :api do
  #   resources :posts
  # end
  # namespaceは標準のルートの/の間にフォルダー名を入れられる
  namespace :api, default: {format: :json} do
    # resources :posts, only: :create# createのみのルートを作る
    resources :posts do# 7つのアクションのルートを作る
      member do
        get :my_post_show_web_user_id# 追加でid付き(web_user_id)のルートを作る
        put :update_post_id# 追加でid付き(web_user_id)のルートを作る
      end
    end
  end
  # mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/auth/registrations'
    }
  end
end
