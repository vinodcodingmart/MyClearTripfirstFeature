class AddPreviousContentColumnToHotels < ActiveRecord::Migration[5.2]
  def change
    add_column :hotels, :previous_content, :text
  end
end
