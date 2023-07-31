class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_one_attached :image

  validates :title, presence: true, length: {minimum: 1}
  validates :text, presence: true, length: {minimum: 1}
end
