class Post < ActiveRecord::Base
    validates :title, presence: true, length: { minimum: 5 }
    mount_uploader :image, ImageUploader
    has_many :comments, dependent: :destroy
    paginates_per 5
  end