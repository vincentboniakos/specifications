class RenameNameToUsers < ActiveRecord::Migration
  def up
    rename_column :users, :firstname, :first_name
    rename_column :users, :lastname, :last_name
  end

  def down
  end
end
