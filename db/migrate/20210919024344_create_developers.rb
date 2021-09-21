class CreateDevelopers < ActiveRecord::Migration[6.1]
  def change
    create_table :developers do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false

      t.timestamps
    end
  end
end
