module MtweetsHelper
  def mtweet_lists(mtweets)
    html = ''
    mtweets.each do |mtweet|
      html += render(partial: 'mtweet',locals: { mtweet: mtweet })
    end
    return raw(html)
  end
end