class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @user = current_user
      @castle = @user.castles.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def about
  end
end
