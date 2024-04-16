class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :mtweets
  has_many :comments  # commentsテーブルとのアソシエーション
end
