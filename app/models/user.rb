class User < ApplicationRecord
  has_many :microposts

  validates :name,  presence: true,   on: :create
  validates :email, presence: true,   on: :create
end
