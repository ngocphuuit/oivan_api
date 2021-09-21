class AddUniqueIndexToDevelopers < ActiveRecord::Migration[6.1]
  def change
  	add_index :developers, [:firstname, :lastname], unique: true
  end
end
