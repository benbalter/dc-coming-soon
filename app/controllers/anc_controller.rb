class AncController < ApplicationController
  caches_action :show

  def show
    @anc = Anc.find(params[:id])
    @abra_notices = @anc.abra_notices.paginate(:page => params[:page]).
      order "abra_notices.posting_date desc"
  end
end
