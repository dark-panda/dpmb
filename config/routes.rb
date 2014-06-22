
Rails.application.routes.draw do
  root 'home#index'

  get '/*path', to: 'home#index', constraints: { path: /.*/ }
  post '/*path', to: 'home#index', constraints: { path: /.*/ }
end

