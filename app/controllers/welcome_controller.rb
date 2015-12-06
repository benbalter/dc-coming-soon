class WelcomeController < ApplicationController
  def index
    @ancs = Anc.all.order :name
    @wards = Ward.all.order :id
  end
end
