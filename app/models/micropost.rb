class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  scope :search_by_key_word, -> (keyword) {
    where("microposts.content LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present?
  }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 150}
  validate :picture_size
  has_many :likes, dependent: :destroy
  has_many :fav_users, through: :likes, source: :user

  def fav(user)
    likes.create(user_id: user.id)
  end

  def unfav(user)
    likes.find_by(user_id: user.id).destroy
  end

  def fav?(user)
    fav_users.include?(user)
  end

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
    
  end
end
