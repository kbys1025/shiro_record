class Castle < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :picture, presence: { message: "を選択してください" }
  validates :user_id, presence: true
  validates :name, presence: true
  validates :location, presence: true
  validates :comment, presence: true, length: { maximum: 255 }
  validate :picture_size

  def post_feed
    Post.where("castle_id = ?", id)
  end

end
