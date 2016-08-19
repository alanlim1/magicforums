class Topic < ApplicationRecord
	has_many :posts
	validates :title, length: { minimum: 5 }, presence: true
	validates :description, length: { minimum: 10 }, presence: true
    include FriendlyId
    friendly_id :title, :use => :slugged

end
