class AddProjectIdToVersion < ActiveRecord::Migration
  def change
    add_column :versions, :project_id, :integer
  end
end
