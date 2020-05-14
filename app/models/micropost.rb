class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope ->{order created_at: :desc}
  scope :by_authors, ->(ids){where user_id: ids}
  validates :content, presence: true, length: {maximum: Settings.microposts.max_size_content}
  validates :image, content_type: {in: Settings.microposts.format_type_img,
                      message: I18n.t("microposts.img_format_invalid")},
                    size: {less_than: Settings.microposts.max_size_img.megabytes,
                      message: I18n.t("microposts.img_size_invalid", size: Settings.microposts.max_size_img)}

  def display_image
    image.variant resize_to_limit: Settings.microposts.resize_img
  end
end
