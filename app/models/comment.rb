class Comment < ApplicationRecord
	belongs_to :post
	mount_uploader :image, ImageUploader
end
