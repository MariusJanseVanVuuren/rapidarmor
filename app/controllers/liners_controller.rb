class LinersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_liner, only: [:show, :edit, :update, :destroy]

  # GET /liners
  # GET /liners.json
  def index
    @liners = Liner.all
  end

  # GET /liners/1
  # GET /liners/1.json
  def show
  end

  def get
    @liner = Liner.find_by(liner_reference: params[:liner][:liner_reference])
    render :json => @liner.to_json
  end

  # GET /liners/new
  def new
    @liner = Liner.new
  end

  # GET /liners/1/edit
  def edit
  end

  # Import
  def import
    Liner.import(params[:file])
    redirect_to liners_path, notice: "Activity data imported"
  end

  # POST /liners
  # POST /liners.json
  def create
    company_name = params[:liner][:company_name]
    company = Company.find_or_create_by name: company_name
    @liner = company.liners.new(liner_params)

    respond_to do |format|
      if @liner.save
        format.html { redirect_to @liner, notice: 'Liner was successfully created.' }
        format.json { render :show, status: :created, location: @liner }
      else
        format.html { render :new }
        format.json { render json: @liner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /liners/1
  # PATCH/PUT /liners/1.json
  def update
    respond_to do |format|
      liner = Liner.find_by(liner_reference: liner_params["liner_reference"])
      original_thickness = liner.original_thickness.to_i
      current_thickness = liner_params["current_thickness"].to_i
      thickness_loss_per_day = original_thickness - current_thickness
      liner_params["thickness_loss_per_day"] = thickness_loss_per_day
      if @liner.update(liner_params)
        format.html { redirect_to @liner, notice: 'Liner was successfully updated.' }
        format.json { render :show, status: :ok, location: @liner }
      else
        format.html { render :edit }
        format.json { render json: @liner.errors, status: :unprocessable_entity }
      end
    end
  end

  def measure
    liner = Liner.find_by(liner_reference: liner_params["liner_reference"])
    original_thickness = liner.original_thickness.to_i
    current_thickness = liner_params["current_thickness"].to_i
    if original_thickness == nil
      original_thickness = current_thickness
      liner.original_thickness = current_thickness
    end
    liner.current_thickness = current_thickness
    liner.thickness_loss_per_day = original_thickness - current_thickness
    puts(liner)
    if liner.save
      puts(liner.to_json)
      render :json => liner.to_json
    else
      render status: 400, json: {
        message: "Unable to replace liner",
      }.to_json
    end
  end

  def replace
    newLiner = Liner.find_by(liner_reference: params[:liner][:new_liner_reference])
    previousLiner = Liner.find_by(liner_reference: params[:liner][:previous_liner_reference])
    newLiner.row = previousLiner.row
    newLiner.collumn = previousLiner.collumn
    newLiner.company = previousLiner.company
    if newLiner.save
      render :json => newLiner.to_json
    else
      render status: 400, json: {
        message: "Unable to replace liner",
      }.to_json
    end
  end

  def swap
    newLiner = Liner.find_by(liner_reference: params[:liner][:new_liner_reference])
    newLinerCurrentRow = newLiner.row
    newLinerCurrentCollumn = newLiner.collumn
    previousLiner = Liner.find_by(liner_reference: params[:liner][:previous_liner_reference])
    previousLinerCurrentRow = previousLiner.row
    previousLinerCurrentCollumn = previousLiner.collumn

    newLiner.row = previousLinerCurrentRow
    newLiner.collumn = previousLinerCurrentCollumn
    previousLiner.row = newLinerCurrentRow
    previousLiner.collumn = newLinerCurrentCollumn

    if previousLiner.save && newLiner.save
      render :json => newLiner.to_json
    else
      render status: 400, json: {
        message: "Unable to swap liners",
      }.to_json
    end
  end

  # DELETE /liners/1
  # DELETE /liners/1.json
  def destroy
    @liner.destroy
    respond_to do |format|
      format.html { redirect_to liners_url, notice: 'Liner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_liner
      @liner = Liner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def liner_params
      puts(params)
      params.require(:liner).permit(:new_liner_reference, :previous_liner_reference, :liner_reference, :location, :row, :collumn, :structure, :plant, :width, :height, :thickness, :original_thickness, :thickness_loss_per_day, :current_thickness)
    end
end
