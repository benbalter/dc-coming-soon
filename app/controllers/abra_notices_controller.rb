class AbraNoticesController < ApplicationController
  before_action :set_abra_notice, only: [:show, :edit, :update, :destroy]

  # GET /abra_notices
  # GET /abra_notices.json
  def index
    @abra_notices = AbraNotice.all
  end

  # GET /abra_notices/1
  # GET /abra_notices/1.json
  def show
  end

  # GET /abra_notices/new
  def new
    @abra_notice = AbraNotice.new
  end

  # GET /abra_notices/1/edit
  def edit
  end

  # POST /abra_notices
  # POST /abra_notices.json
  def create
    @abra_notice = AbraNotice.new(abra_notice_params)

    respond_to do |format|
      if @abra_notice.save
        format.html { redirect_to @abra_notice, notice: 'Abra notice was successfully created.' }
        format.json { render :show, status: :created, location: @abra_notice }
      else
        format.html { render :new }
        format.json { render json: @abra_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /abra_notices/1
  # PATCH/PUT /abra_notices/1.json
  def update
    respond_to do |format|
      if @abra_notice.update(abra_notice_params)
        format.html { redirect_to @abra_notice, notice: 'Abra notice was successfully updated.' }
        format.json { render :show, status: :ok, location: @abra_notice }
      else
        format.html { render :edit }
        format.json { render json: @abra_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /abra_notices/1
  # DELETE /abra_notices/1.json
  def destroy
    @abra_notice.destroy
    respond_to do |format|
      format.html { redirect_to abra_notices_url, notice: 'Abra notice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_abra_notice
      @abra_notice = AbraNotice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def abra_notice_params
      params.require(:abra_notice).permit(:posting_date, :petition_date, :hearing_date, :protest_date, :anc_id, :license_class_id)
    end
end
