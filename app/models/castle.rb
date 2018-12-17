class Castle < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :picture, presence: true
  validates :user_id, presence: true
  validates :name, presence: true
  validates :location, presence: true
  validates :comment, presence: true, length: { maximum: 255 }
  validate :picture_size

  private

    # アップされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "画像サイズが5MBを超えています")
      end
    end

end
