class AncController < ApplicationController
  def index

  end

  def show
    @anc = Anc.find(params[:id])
    @abra_notices = @anc.abra_notices
  end
end
