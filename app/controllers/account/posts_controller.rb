# frozen_string_literal: true
class Account::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post_and_check_permission, only: %i(edit update destroy)

  def index
    @posts = current_user.posts.recent_updated
  end

  def edit; end

  def update
    if @post.update(post_params)
      @post.submit! if params[:commit].in?(%w[Submit Update])
      redirect_to account_posts_path, notice: "Update Success"
    else
      render "edit"
    end
  end

  def destroy
    @post.cancel!

    redirect_to account_posts_path, alert: "Group #{params[:commit]}ed"
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
