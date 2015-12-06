Rails.application.routes.draw do
  root 'welcome#index'
  resources :ward, :only => [:show]
  resources :anc,  :only => [:show]
  resources :abra_notices, :only => [:index, :show], :path => "/notices"
end
