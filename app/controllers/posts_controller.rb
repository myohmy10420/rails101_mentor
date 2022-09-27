# frozen_string_literal: true
class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i(new create)
  before_action :find_group
  before_action :find_post_and_check_permission, only: %i(edit update destroy)

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.group = @group
    @post.author = current_user

    if @post.save
      redirect_to group_path(@group)
    else
      render "new"
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to group_path(@group), notice: "Update Success"
    else
      render "edit"
    end
  end

  def destroy
    @post.destroy

    redirect_to group_path(@group), alert: "Group deleted"
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_post_and_check_permission
    @post = Post.find(params[:id])

    redirect_to root_path, alert: "You have no permission." if current_user != @post.author
  end
end
