Rails.application.routes.draw do
  resources :data do
    collection do
      post 'import'
      post 'update_hotel_content'
    end
  end
  resources :hotels do
    collection do
      post 'import'
    end
  end
  root to: "hotels#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
