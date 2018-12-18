class Post < ApplicationRecord
  belongs_to :castle
  default_scope -> { order(created_at: :asc) }
  mount_uploader :picture, PictureUploader
  validates :picture, presence: true
  validates :castle_id, presence: true
  validate :picture_size

end
