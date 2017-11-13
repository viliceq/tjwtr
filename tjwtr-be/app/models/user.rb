class User < ApplicationRecord
  has_many :posts
  validates :email, uniqueness: true
  validates :name, uniqueness: true
  validates :password, presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
end
