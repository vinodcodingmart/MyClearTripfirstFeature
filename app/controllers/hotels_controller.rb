require 'csv'
class HotelsController < ApplicationController
  before_action :set_hotel, only: [:show, :edit, :update, :destroy]

  # GET /hotels
  # GET /hotels.json
  def index
    @hotels = Hotel.all
  end

  # GET /hotels/1
  # GET /hotels/1.json
  def show
  end

  # GET /hotels/new
  def new
    @hotel = Hotel.new
  end

  # GET /hotels/1/edit
  def edit
  end

  # POST /hotels
  # POST /hotels.json
  def create
    @hotel = Hotel.new(hotel_params)
    respond_to do |format|
      if @hotel.save
        @hotel.update(url: "http://localhost:3000/hotels/#{@hotel.id}")
        format.html { redirect_to @hotel, notice: 'Hotel was successfully created.' }
        format.json { render :show, status: :created, location: @hotel }
      else
        format.html { render :new }
        format.json { render json: @hotel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hotels/1
  # PATCH/PUT /hotels/1.json
  def update
    respond_to do |format|
      if @hotel.update(hotel_params)
        format.html { redirect_to @hotel, notice: 'Hotel was successfully updated.' }
        format.json { render :show, status: :ok, location: @hotel }
      else
        format.html { render :edit }
        format.json { render json: @hotel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hotels/1
  # DELETE /hotels/1.json
  def destroy
    @hotel.destroy
    respond_to do |format|
      format.html { redirect_to hotels_url, notice: 'Hotel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if params[:file].present?
      slot = params[:slot] #params[:slot].present? ? params[:slot] : "a"
      @hotels = Hotel.all
      @hotels.each { |hotel|
          hotel.update(content: hotel.previous_content) if hotel.previous_content.present?
        }
      # csv_data = CSV.read("#{Rails.root.join}/public/data.csv")
      csv_data = CSV.parse(File.read(params[:file].path), headers: true)
      keyword_apply_count ={}
      csv_data.each{|rec|
        keyword_apply_count[rec["keyword"]]||=0 
        @hotels.each { |hotel|
          if hotel.content.downcase.include?(rec["keyword"].downcase) && rec["slot"] == slot && keyword_apply_count[rec["keyword"]] < 3
            hotel.update(previous_content: hotel.content) unless hotel.previous_content.present?
            content = hotel.content
            sub_content_index = content.downcase.index(rec["keyword"].downcase)
            content[sub_content_index...(sub_content_index+rec["keyword"].length)] = "<a href= '#{rec["url"]}'>#{rec["keyword"]}</a>"
            hotel.update(content: content)
            keyword_apply_count[rec["keyword"]]+=1
          end
        }
      }
    else
      flash[:notice] = "Please Select Valid CSV file"
    end
    redirect_to hotels_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hotel
      @hotel = Hotel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hotel_params
      params.require(:hotel).permit(:name, :content)
    end
end
