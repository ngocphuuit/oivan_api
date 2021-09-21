class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date

      t.timestamps
    end
  end
end
