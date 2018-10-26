Rails.application.routes.draw do

  scope '/api' do
    resources :tasks
    resources :users, only: [:show, :update, :create]
  end
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	post 'api/auth', to: 'auth#auth'
end
