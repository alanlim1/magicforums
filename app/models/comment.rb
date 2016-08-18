class Comment < ApplicationRecord
	belongs_to :post
	mount_uploader :image, ImageUploader
	validates :body, length: { minimum: 10 }, presence: true
	belongs_to :user
    max_paginates_per 5
    paginates_per 5
    has_many :votes
    include FriendlyId
    friendly_id :body, :use => :slugged


    def total_votes
        votes.pluck(:value).sum
    end
end
