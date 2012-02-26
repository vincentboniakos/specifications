class AddIndexToStakeholders < ActiveRecord::Migration
  def change
  	    add_index :stakeholders, :user_id
    	add_index :stakeholders, :project_id
  end
end
