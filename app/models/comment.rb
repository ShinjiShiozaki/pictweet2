class Comment < ApplicationRecord
  belongs_to :mtweet  # mtweetsテーブルとのアソシエーション
  belongs_to :user  # usersテーブルとのアソシエーション
end
