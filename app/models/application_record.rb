class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

    # アップされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "画像サイズが5MBを超えています")
      end
    end
    
end
