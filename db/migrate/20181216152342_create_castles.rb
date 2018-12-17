class CreateCastles < ActiveRecord::Migration[5.1]
  def change
    create_table :castles do |t|
      t.string :name
      t.string :location
      t.text :comment
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :castles, [:user_id, :created_at]
  end
end
