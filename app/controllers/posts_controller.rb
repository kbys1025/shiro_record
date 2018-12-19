class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def show
    @post = Post.find(params[:id])
    @castle = Castle.find_by(id: @post.castle_id)
    @user = @castle.user
  end

  def create
    @castle = Castle.find(params[:castle_id])
    @post = @castle.posts.build(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:success] = "写真を追加しました！"
      redirect_to user_castle_path(@castle.user, @castle)
    else
      render 'castles/show'
    end
  end

  def edit
    @post = Post.find(params[:id])
    @castle = @post.castle
    @user = @castle.user
  end

  def update
    @post = Post.find(params[:id])
    @castle = @post.castle
    @user = @castle.user
    if @post.update_attributes(post_params)
      flash[:success] = "変更を保存しました"
      redirect_to user_castle_post_path(@user, @castle, @post)
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @castle = Castle.find(params[:castle_id])
    @post.destroy
    flash[:success] = "写真を削除しました"
    redirect_to user_castle_path(@castle.user, @castle)
  end

  private

    def post_params
      params.fetch(:post, {}).permit(:picture, :comment)
    end

    # beforeフィルター

    #def correct_user
    #  @post = Post.find_by(id: params[:id])
    #  redirect_to root_url unless @post.user_id == current_user.id
    #end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end

end
