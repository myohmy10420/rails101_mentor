# frozen_string_literal: true
class Account::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post_and_check_permission, only: %i(edit update destroy)

  def index
    @posts = current_user.posts
  end

  def edit; end

  def update
    if @post.update(post_params)
      @post.submit!
      redirect_to account_posts_path, notice: "Update Success"
    else
      render "edit"
    end
  end

  def destroy
    @post.destroy

    redirect_to account_posts_path, alert: "Group deleted"
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def find_post_and_check_permission
    @post = Post.find(params[:id])

    redirect_to root_path, alert: "You have no permission." if current_user != @post.author
  end
end
