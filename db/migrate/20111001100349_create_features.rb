class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.string :description
      t.integer :project_id

      t.timestamps
    end
    add_index :features, :project_id
    add_index :features, :created_at
  end
end
