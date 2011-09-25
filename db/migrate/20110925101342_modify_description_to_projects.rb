class ModifyDescriptionToProjects < ActiveRecord::Migration
  def up
    change_column :projects, :description, :text
  end

  def down
  end
end
