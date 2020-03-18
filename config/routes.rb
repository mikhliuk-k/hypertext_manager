Rails.application.routes.draw do

  root to: 'home#show'

  resource :home

end
