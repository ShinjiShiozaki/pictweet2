require 'rails_helper'

RSpec.describe 'ツイート投稿', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @mtweet_text = Faker::Lorem.sentence
    @mtweet_image = Faker::Lorem.sentence
  end
  context 'ツイート投稿ができるとき'do
  it 'ログインしたユーザーは新規投稿できる' do
    # ログインする
    sign_in(@user)
    # 新規投稿ページへのボタンがあることを確認する
    expect(page).to have_content('投稿する')
    # 投稿ページに移動する
    visit new_mtweet_path
    # フォームに情報を入力する
    fill_in 'mtweet_image', with: @mtweet_image
    fill_in 'mtweet_text', with: @mtweet_text
    # 送信するとTweetモデルのカウントが1上がることを確認する
    expect{
      find('input[name="commit"]').click
      sleep 1
    }.to change { Mtweet.count }.by(1)
    # トップページには先ほど投稿した内容のツイートが存在することを確認する（画像）
    expect(page).to have_selector ".content_post[style='background-image: url(#{@mtweet_image});']"
    # トップページには先ほど投稿した内容のツイートが存在することを確認する（テキスト）
    expect(page).to have_content(@mtweet_text)
  end
end
  context 'ツイート投稿ができないとき'do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 新規投稿ページへのボタンがないことを確認する
      expect(page).to have_no_content('投稿する')
    end
  end
end

RSpec.describe 'ツイート編集', type: :system do
  before do
    @mtweet1 = FactoryBot.create(:mtweet)
    @mtweet2 = FactoryBot.create(:mtweet)
  end
  context 'ツイート編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿したツイートの編集ができる' do
      # ツイート1を投稿したユーザーでログインする
      sign_in(@mtweet1.user)
      # ツイート1に「編集」へのリンクがあることを確認する
      expect(
        all('.more')[1].hover
      ).to have_link '編集', href: edit_mtweet_path(@mtweet1)
      # 編集ページへ遷移する
      visit edit_mtweet_path(@mtweet1)
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(page).to have_field('mtweet_image', with: @mtweet1.image)
      expect(page).to have_field('mtweet_text', with: @mtweet1.text)
      # 投稿内容を編集する
      fill_in 'mtweet_image', with: "#{@mtweet1.image}+編集した画像URL"
      fill_in 'mtweet_text', with: "#{@mtweet1.text}+編集したテキスト"
      # 編集してもTweetモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { Mtweet.count }.by(0)
      # トップページには先ほど変更した内容のツイートが存在することを確認する（画像）
      expect(page).to have_selector ".content_post[style='background-image: url(#{@mtweet1.image}+編集した画像URL);']"
      # トップページには先ほど変更した内容のツイートが存在することを確認する（テキスト）
      expect(page).to have_content("#{@mtweet1.text}+編集したテキスト")
    end
  end
  context 'ツイート編集ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したツイートの編集画面には遷移できない' do
      # ツイート1を投稿したユーザーでログインする
      sign_in(@mtweet1.user)
      # ツイート2に「編集」へのリンクがないことを確認する
      expect(
        all('.more')[0].hover
      ).to have_no_link '編集', href: edit_mtweet_path(@mtweet2)
    end
    it 'ログインしていないとツイートの編集画面には遷移できない' do
      # トップページにいる
      visit root_path
      # ツイート1に「編集」へのリンクがないことを確認する
      expect(
        all('.more')[1].hover
      ).to have_no_link '編集', href: edit_mtweet_path(@mtweet1)
      # ツイート2に「編集」へのリンクがないことを確認する
      expect(
        all('.more')[0].hover
      ).to have_no_link '編集', href: edit_mtweet_path(@mtweet2)
    end
  end
end

RSpec.describe 'ツイート削除', type: :system do
  before do
    @mtweet1 = FactoryBot.create(:mtweet)
    @mtweet2 = FactoryBot.create(:mtweet)
  end
  context 'ツイート削除ができるとき' do
    it 'ログインしたユーザーは自らが投稿したツイートの削除ができる' do
      # ツイート1を投稿したユーザーでログインする
      sign_in(@mtweet1.user)
      # ツイート1に「削除」へのリンクがあることを確認する
      expect(
        all('.more')[1].hover
      ).to have_link '削除', href: mtweet_path(@mtweet1)
      # 投稿を削除するとレコードの数が1減ることを確認する
      expect{
        all('.more')[1].hover.find_link('削除', href: mtweet_path(@mtweet1)).click
        sleep 1
      }.to change { Mtweet.count }.by(-1)
      # トップページにはツイート1の内容が存在しないことを確認する（画像）
      expect(page).to have_no_selector ".content_post[style='background-image: url(#{@mtweet1.image});']"
      # トップページにはツイート1の内容が存在しないことを確認する（テキスト）
      #binding.pry
      expect(page).to have_no_content("#{@mtweet1.text}")
    end
  end
  context 'ツイート削除ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したツイートの削除ができない' do
      # ツイート1を投稿したユーザーでログインする
      sign_in(@mtweet1.user)
      # ツイート2に「削除」へのリンクがないことを確認する
      expect(
        all('.more')[0].hover
      ).to have_no_link '削除', href: mtweet_path(@mtweet2)
    end
    it 'ログインしていないとツイートの削除ボタンがない' do
      # トップページに移動する
      visit root_path
      # ツイート1に「削除」へのリンクがないことを確認する
      expect(
        all('.more')[1].hover
      ).to have_no_link '削除', href: mtweet_path(@mtweet1)
      # ツイート2に「削除」へのリンクがないことを確認する
      expect(
        all('.more')[0].hover
      ).to have_no_link '削除', href: mtweet_path(@mtweet2)
    end
  end
end

RSpec.describe 'ツイート詳細', type: :system do
  before do
    @mtweet = FactoryBot.create(:mtweet)
  end
  it 'ログインしたユーザーはツイート詳細ページに遷移してコメント投稿欄が表示される' do
    # ログインする
    sign_in(@mtweet.user)
    # ツイートに「詳細」へのリンクがある
    expect(
      all(".more")[0].hover
    ).to have_link '詳細', href: mtweet_path(@mtweet)
    # 詳細ページに遷移する
    #visit tweet_path(@mtweet)
    visit mtweet_path(@mtweet)
    # 詳細ページにツイートの内容が含まれている
    expect(page).to have_selector ".content_post[style='background-image: url(#{@mtweet.image});']"
    expect(page).to have_content("#{@mtweet.text}")
    # コメント用のフォームが存在する
    expect(page).to have_selector 'form'
  end
  it 'ログインしていない状態でツイート詳細ページに遷移できるもののコメント投稿欄が表示されない' do
    # トップページに移動する
    visit root_path
    # ツイートに「詳細」へのリンクがある
    expect(
      all(".more")[0].hover
    ).to have_link '詳細', href: mtweet_path(@mtweet)
    # 詳細ページに遷移する
    visit mtweet_path(@mtweet)
    # 詳細ページにツイートの内容が含まれている
    expect(page).to have_selector ".content_post[style='background-image: url(#{@mtweet.image});']"
    expect(page).to have_content("#{@mtweet.text}")
    # フォームが存在しないことを確認する
    expect(page).to have_no_selector 'form'
    # 「コメントの投稿には新規登録/ログインが必要です」が表示されていることを確認する
    expect(page).to have_content 'コメントの投稿には新規登録/ログインが必要です'
  end
end