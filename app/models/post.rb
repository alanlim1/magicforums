class Post < ApplicationRecord
	has_many :comments
	belongs_to :topic
	mount_uploader :image, ImageUploader
	validates :title, length: { minimum: 5 }, presence: true
	validates :body, length: { minimum: 10 }, presence: true
	belongs_to :user
    max_paginates_per 5
    paginates_per 5
end
