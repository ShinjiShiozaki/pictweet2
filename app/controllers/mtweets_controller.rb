class MtweetsController < ApplicationController
  before_action :set_mtweet, only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    @mtweets = Mtweet.includes(:user).order("created_at DESC")
  end

  def new
    @mtweet = Mtweet.new
  end

  def create
    Mtweet.create(ptweet_params)
    redirect_to '/'
  end

  def destroy
    ytweet = Mtweet.find(params[:id])
    ytweet.destroy
    redirect_to root_path
  end

  def edit
  end
  
  def update
    ytweet = Mtweet.find(params[:id])
    ytweet.update(ptweet_params)
    redirect_to root_path
  end
  
  def show
    @comment = Comment.new
    @comments = @mtweet.comments.includes(:user)
  end

  def search
    #@mtweets = Mtweet.search(params[:keyword])
    @mtweets = SearchTweetsService.search(params[:keyword])
  end
  private

  def ptweet_params
    params.require(:mtweet).permit(:image, :text).merge(user_id: current_user.id)
  end

  def set_mtweet
    @mtweet = Mtweet.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end
end
