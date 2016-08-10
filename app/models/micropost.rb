class Micropost < ApplicationRecord
  validates :content, length: { maximum: 140 },
                      presence: true
  validates :user_id, presence: true

  validate :picture_size

  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  mount_uploader :picture, PictureUploader

  private

    # 验证上传的图像大小
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
