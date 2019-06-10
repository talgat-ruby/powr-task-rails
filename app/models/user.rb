class User < ApplicationRecord
  validates :username, uniqueness: true
  validates :email, uniqueness: true
  validates :oauth_token, presence: true
end
