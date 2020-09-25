Rails.application.routes.draw do
  devise_for :users
root to:"temporarys#index"
resources :temporarys  do
  resources :meetings , only: [:new , :create , :show , :edit , :update , :destroy]
  resources :contracts , only: [:new , :create , :edit , :update , :destroy]
  collection do
    get :search
  end
end
resources :companies
resources :meetings , only: :index
get 'meeting/search_temporary' => "meetings#search"
end
