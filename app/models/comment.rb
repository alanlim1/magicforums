class Comment < ApplicationRecord
	belongs_to :post
	mount_uploader :image, ImageUploader
	validates :body, length: { minimum: 10 }, presence: true
	belongs_to :user
    max_paginates_per 5
    paginates_per 5
end
