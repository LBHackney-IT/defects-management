Rails.application.routes.draw do
  root to: 'staff/dashboard#index'
  get 'check' => 'application#check'
  resources :estates, controller: 'staff/estates', only: %i[new create show] do
    resources :schemes, controller: 'staff/schemes', only: %i[new create show edit update] do
      resources :priorities, controller: 'staff/priorities', only: %i[new create]
      resources :properties, controller: 'staff/properties',
                             only: %i[new create edit update] do
      end
    end
  end

  get 'search' => 'staff/searches#index'
  resources :properties, controller: 'staff/properties', only: %i[show] do
    resources :defects, controller: 'staff/defects', only: %i[new create show edit update] do
      resources :comments, controller: 'staff/comments', only: %i[new create edit update]
    end
  end

  resources :defects, controller: 'contractor/defects' do
    get :accept
  end
end
