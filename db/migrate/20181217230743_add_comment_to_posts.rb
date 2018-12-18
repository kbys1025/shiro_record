class AddCommentToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :comment, :string
  end
end
