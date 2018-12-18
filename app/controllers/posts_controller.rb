class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def show
    @post = Post.find(params[:id])
    @castle = Castle.find_by(id: @post.castle_id)
  end

  def create
    @castle = Castle.find(params[:castle_id])
    @post = @castle.posts.build(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:success] = "写真を追加しました！"
      redirect_to @castle
    else
      render 'castles/show'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "変更を保存しました"
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @castle = Castle.find(params[:castle_id])
    @post.destroy
    flash[:success] = "写真を削除しました"
    redirect_to @castle
  end

  private

    def post_params
      params.fetch(:post, {}).permit(:picture, :comment)
    end

end
