class CastlesController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @castles = Castle.paginate(page: params[:page])
  end

  def show
    @castle = Castle.find(params[:id])
    @post = @castle.posts.build
    @user = @castle.user
  end

  def create
    @castle = current_user.castles.build(castle_params)
    if @castle.save
      flash[:success] = "お城の記録を作成しました"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def edit
    @castle = Castle.find(params[:id])
    @user = @castle.user
  end

  def update
    @castle = Castle.find(params[:id])
    @user = @castle.user
    if @castle.update_attributes(castle_params)
      flash[:success] = "変更を保存しました"
      redirect_to user_castle_path(@user, @castle)
    else
      render 'edit'
    end
  end

  def destroy
    @user = current_user
    @castle.destroy
    flash[:success] = "お城の記録を削除しました"
    redirect_to request.referrer || root_url
  end

  private

    def castle_params
      params.require(:castle).permit(:name, :location, :picture, :comment)
    end

    # beforeフィルター

    def correct_user
      @castle = current_user.castles.find_by(id: params[:id])
      redirect_to root_url if @castle.nil?
    end


end
