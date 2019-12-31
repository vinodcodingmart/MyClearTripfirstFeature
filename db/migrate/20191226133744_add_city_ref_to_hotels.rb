class AddCityRefToHotels < ActiveRecord::Migration[5.2]
  def change
    add_reference :hotels, :city, foreign_key: true
  end
end
