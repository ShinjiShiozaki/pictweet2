require 'rails_helper'

RSpec.describe Mtweet, type: :model do
  before do
    @mtweet = FactoryBot.build(:mtweet)
  end

  describe 'ツイートの保存' do
    context 'ツイートが投稿できる場合' do
      it '画像とテキストを投稿できる' do
        expect(@mtweet).to be_valid
      end
      it 'テキストのみで投稿できる' do
        @mtweet.image = ''
        expect(@mtweet).to be_valid
      end
    end
    context 'ツイートが投稿できない場合' do
      it 'テキストが空では投稿できない' do
        @mtweet.text = ''
        @mtweet.valid?
        expect(@mtweet.errors.full_messages).to include("Text can't be blank")
      end     
      it 'ユーザーが紐付いていなければ投稿できない' do
        @mtweet.user = nil
        @mtweet.valid?
        expect(@mtweet.errors.full_messages).to include('User must exist')
      end
    end
  end
end
