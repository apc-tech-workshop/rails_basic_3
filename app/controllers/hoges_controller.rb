class HogesController < ApplicationController
  before_action :set_hoge, only: [:show, :edit, :update, :destroy]

  # GET /hoges
  # GET /hoges.json
  def index
    @hoges = Hoge.all
  end

  # GET /hoges/1
  # GET /hoges/1.json
  def show
  end

  # GET /hoges/new
  def new
    @hoge = Hoge.new
  end

  # GET /hoges/1/edit
  def edit
  end

  # POST /hoges
  # POST /hoges.json
  def create
    @hoge = Hoge.new(hoge_params)

    respond_to do |format|
      if @hoge.save
        format.html { redirect_to @hoge, notice: 'Hoge was successfully created.' }
        format.json { render :show, status: :created, location: @hoge }
      else
        format.html { render :new }
        format.json { render json: @hoge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hoges/1
  # PATCH/PUT /hoges/1.json
  def update
    respond_to do |format|
      if @hoge.update(hoge_params)
        format.html { redirect_to @hoge, notice: 'Hoge was successfully updated.' }
        format.json { render :show, status: :ok, location: @hoge }
      else
        format.html { render :edit }
        format.json { render json: @hoge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hoges/1
  # DELETE /hoges/1.json
  def destroy
    @hoge.destroy
    respond_to do |format|
      format.html { redirect_to hoges_url, notice: 'Hoge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hoge
      @hoge = Hoge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hoge_params
      params.require(:hoge).permit(:name)
    end
end
