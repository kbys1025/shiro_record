class AddPictureToCastles < ActiveRecord::Migration[5.1]
  def change
    add_column :castles, :picture, :string
  end
end
