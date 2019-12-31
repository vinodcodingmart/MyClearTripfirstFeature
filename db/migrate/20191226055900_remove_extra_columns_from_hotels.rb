class RemoveExtraColumnsFromHotels < ActiveRecord::Migration[5.2]
  def change
    remove_column :hotels, :url
    remove_column :hotels, :slot
  end
end
