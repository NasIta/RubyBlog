class User < ApplicationRecord
  validates :name, presence: true, length: {minimum: 2}
  validates :posted, presence: true
  validates :registered_at, presence: true

  has_many :posts
  has_many :comments
end