class User < ApplicationRecord
	has_secure_password
	has_many :topics
	has_many :posts
	has_many :comments
    has_many :votes

	validates :email, uniqueness: true
	enum role: [:user, :moderator, :admin]
end
