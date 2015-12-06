class WardController < ApplicationController
  def show
    @ward = Ward.find(params[:id])
    @abra_notices = @ward.abra_notices.paginate(:page => params[:page]).
      order "abra_notices.posting_date desc"
  end
end
