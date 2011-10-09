class CreateUserstories < ActiveRecord::Migration
  def change
    create_table :userstories do |t|
      t.string :content
      t.integer :feature_id

      t.timestamps
    end
    add_index :userstories, :feature_id
  end
end
