class AncController < ApplicationController
  caches_action :show

  def show
    @anc = Anc.find(params[:id])
    @postings = @anc.postings.paginate(:page => params[:page])
  end
end
