Rails.application.routes.draw do

  root to: redirect('editor')

  resource :editor, controller: :editor do
    get :preview
  end

  resources :entities

  resource :toolbox, controller: :toolbox do
    post :find
  end

  resource :search, controller: :search do
    get :check
  end

end
