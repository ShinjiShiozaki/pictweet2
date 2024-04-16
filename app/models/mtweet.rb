class Mtweet < ApplicationRecord
  validates :text, presence: true
  belongs_to :user
  has_many :comments  # commentsテーブルとのアソシエーション

  #def self.search(search)
    #if search != ""
    #  Mtweet.where('text LIKE(?)', "%#{search}%")
    #else
    #  Mtweet.all
    #end
  #end

end
