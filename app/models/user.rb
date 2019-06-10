class User < ApplicationRecord
  validates :oauth_token, presence: true
end
