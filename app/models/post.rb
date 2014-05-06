class Post < ActiveRecord::Base


  validates :title, length: { minimum: 3 }
  validates :title, uniqueness: true
  validates :description, length: { minimum: 0 }
  validates :content, presence: true

  has_many :comments
  belongs_to :user

end
