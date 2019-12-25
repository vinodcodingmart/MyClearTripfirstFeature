class DataController < ApplicationController
  before_action :set_datum, only: [:show, :edit, :update, :destroy]

  # GET /data
  # GET /data.json
  def index
    @data = Datum.all
  end

  # GET /data/1
  # GET /data/1.json
  def show
  end

  # GET /data/new
  def new
    @datum = Datum.new
  end

  # GET /data/1/edit
  def edit
  end

  # POST /data
  # POST /data.json
  def create
    @datum = Datum.new(datum_params)

    respond_to do |format|
      if @datum.save
        format.html { redirect_to @datum, notice: 'Datum was successfully created.' }
        format.json { render :show, status: :created, location: @datum }
      else
        format.html { render :new }
        format.json { render json: @datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data/1
  # PATCH/PUT /data/1.json
  def update
    respond_to do |format|
      if @datum.update(datum_params)
        format.html { redirect_to @datum, notice: 'Datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @datum }
      else
        format.html { render :edit }
        format.json { render json: @datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data/1
  # DELETE /data/1.json
  def destroy
    @datum.destroy
    respond_to do |format|
      format.html { redirect_to data_url, notice: 'Datum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    Datum.import(params[:file])
    redirect_to data_path, notice: "Data imported."
  end

  def update_hotel_content
      slot = params[:slot] #params[:slot].present? ? params[:slot] : "a"
      @hotels = Hotel.all
      @hotels.each { |hotel|
          hotel.update(content: hotel.previous_content) if hotel.previous_content.present?
        }
      # csv_data = CSV.read("#{Rails.root.join}/public/data.csv")
      csv_data = Datum.where(slot: params[:slot])
      csv_data.each{|rec|
        @hotels.each { |hotel|
          if hotel.content.downcase.include?(rec.keyword.downcase) && rec.slot == slot && rec.apply_count < 3
            hotel.update(previous_content: hotel.content) unless hotel.previous_content.present?
            content = hotel.content
            sub_content_index = content.downcase.index(rec.keyword.downcase)
            content[sub_content_index...(sub_content_index+rec.keyword.length)] = "<a href= '#{rec.url}'>#{rec.keyword}</a>"
            hotel.update(content: content)
          end
        }
      }
    redirect_to data_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_datum
      @datum = Datum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def datum_params
      params.require(:datum).permit(:keyword, :url, :slot, :apply_count)
    end
end
