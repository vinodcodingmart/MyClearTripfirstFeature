class AddDefaultValueToColumnApplyCountInInterlinks < ActiveRecord::Migration[5.2]
  def change
    change_column :interlinks, :apply_count, :integer, :default => 0
  end
end
