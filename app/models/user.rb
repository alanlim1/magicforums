class User < ApplicationRecord
	has_secure_password
	has_many :topics, :posts, :comments
end