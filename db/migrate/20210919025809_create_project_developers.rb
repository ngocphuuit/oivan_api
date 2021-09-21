class CreateProjectDevelopers < ActiveRecord::Migration[6.1]
  def change
    create_table :project_developers do |t|
      t.references :project, null: false, foreign_key: true
      t.references :developer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
