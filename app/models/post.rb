class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image

  validates :title, presence: true, length: {minimum: 1}
  validates :text, presence: true, length: {minimum: 1}
  validates :user_id, presence: true

  before_destroy :delete_children

   def delete_children
     comments.destroy_all
   end
end
