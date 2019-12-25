class AddDefaultValueToApplyCountInData < ActiveRecord::Migration[5.2]
  def change
    change_column :data, :apply_count, :integer, :default => 0
  end
end
