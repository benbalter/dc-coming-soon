class WardController < ApplicationController
  caches_action :show

  def show
    @ward = Ward.find(params[:id])
    @postings = @ward.postings.paginate(:page => params[:page])
  end
end
