Rails.application.routes.draw do
  root 'welcome#index'
  resources :postings, :only => [:index]
  resources :locations, :only => [:show]
  resources :ward, :only => [:show]
  resources :anc,  :only => [:show]
  resources :abra_notices, :only => [:show], :path => "/abra-notices"
  resources :zoning_cases, :only => [:show], :path => "/zoning-cases"
end
