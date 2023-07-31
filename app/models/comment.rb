class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :rate, presence: true, numericality: {in: 1..5}
  validates :text, presence: true, length: {minimum: 1}
end
