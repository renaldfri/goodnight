class User < ApplicationRecord
  validates :name, presence: true

  has_many :sleep_records, dependent: :destroy
  has_many :follower_relationships, class_name: 'Follow', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :follower_relationships

  has_many :following_relationships, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :following_relationships, source: :followed

end
