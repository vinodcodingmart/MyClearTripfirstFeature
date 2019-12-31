class InterlinksController < ApplicationController
  before_action :set_interlink, only: [:show, :edit, :update, :destroy]

  # GET /interlinks
  # GET /interlinks.json
  def index
    @selected_slot = 'a'
    if params[:slot].present?
      @interlinks = Interlink.where(slot: params[:slot])
      @selected_slot = params[:slot]
    else
      @interlinks = Interlink.all
    end
  end

  # GET /interlinks/1
  # GET /interlinks/1.json
  def show
  end

  # GET /interlinks/new
  def new
    @interlink = Interlink.new
  end

  # GET /interlinks/1/edit
  def edit
  end

  # POST /interlinks
  # POST /interlinks.json
  def create
    @interlink = Interlink.new(interlink_params)

    respond_to do |format|
      if @interlink.save
        format.html { redirect_to @interlink, notice: 'Interlink was successfully created.' }
        format.json { render :show, status: :created, location: @interlink }
      else
        format.html { render :new }
        format.json { render json: @interlink.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interlinks/1
  # PATCH/PUT /interlinks/1.json
  def update
    respond_to do |format|
      if @interlink.update(interlink_params)
        format.html { redirect_to @interlink, notice: 'Interlink was successfully updated.' }
        format.json { render :show, status: :ok, location: @interlink }
      else
        format.html { render :edit }
        format.json { render json: @interlink.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interlinks/1
  # DELETE /interlinks/1.json
  def destroy
    @interlink.destroy
    respond_to do |format|
      format.html { redirect_to interlinks_url, notice: 'Interlink was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    Interlink.import(params[:file])
    redirect_to interlinks_path, notice: "Data imported."
  end

  def update_hotel_content
      slot = params[:slot] #params[:slot].present? ? params[:slot] : "a"
      @hotels = Hotel.all
      @hotels.each { |hotel|
          hotel.update(content: hotel.previous_content) if hotel.previous_content.present?
        }
      Interlink.update(apply_count: 0)
      # csv_data = CSV.read("#{Rails.root.join}/public/data.csv")
      csv_data = Interlink.where(slot: params[:slot])
      same_keyword_apply_hotel_hash = {}
      csv_data.each{|rec|
        @hotels.each { |hotel|
          same_keyword_apply_hotel_hash[hotel.name]||= []
          if hotel.content.downcase.include?(rec.keyword.downcase) && rec.slot == slot && rec.apply_count < 3 && !same_keyword_apply_hotel_hash[hotel.name].include?(rec.keyword)
            same_keyword_apply_hotel_hash[hotel.name] << rec.keyword
            hotel.update(previous_content: hotel.content) unless hotel.previous_content.present?
            content = hotel.content
            sub_content_index = content.downcase.index(rec.keyword.downcase)
            content[sub_content_index...(sub_content_index+rec.keyword.length)] = "<a href= '#{rec.url}'>#{rec.keyword}</a>"
            hotel.update(content: content)
            rec.update(apply_count: rec.apply_count+1)
          end
        }
      }
    redirect_to interlinks_path(slot: slot)
  end
  def searchcriteria
    render json: Interlink.search(params[:query], {
      fields: ["keyword^5"],
      limit: 10,
      load: false,
      misspellings: {below: 5}
    }).map(&:keyword)
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interlink
      @interlink = Interlink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interlink_params
      params.require(:interlink).permit(:keyword, :url, :slot, :apply_count)
    end
end
