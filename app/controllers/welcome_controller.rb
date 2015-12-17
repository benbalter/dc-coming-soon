class WelcomeController < ApplicationController
  caches_action :index
  
  def index
    @ancs = Anc.all.order :name
    @wards = Ward.all.order :id
  end
end
