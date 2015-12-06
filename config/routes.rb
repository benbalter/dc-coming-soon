Rails.application.routes.draw do
  root 'welcome#index'
  resources :ward, :only => [:index, :show]
  resources :anc,  :only => [:index, :show]
  resources :abra_notices, :only => [:index, :show], :path => "/notices"
end
