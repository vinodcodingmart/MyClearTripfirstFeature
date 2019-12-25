class CreateHotels < ActiveRecord::Migration[5.2]
  def change
    create_table :hotels do |t|
      t.string :name
      t.text :content
      t.string :slot
      t.string :url

      t.timestamps
    end
  end
end
