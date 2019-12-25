class CreateData < ActiveRecord::Migration[5.2]
  def change
    create_table :data do |t|
      t.string :keyword
      t.string :url
      t.string :slot
      t.integer :apply_count

      t.timestamps
    end
  end
end
