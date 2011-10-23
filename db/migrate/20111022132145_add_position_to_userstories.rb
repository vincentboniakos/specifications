class AddPositionToUserstories < ActiveRecord::Migration
  def change
    add_column :userstories, :position, :integer
  end
end
