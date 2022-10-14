# frozen_string_literal: true
class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update destroy verify)
  before_action :find_group
  before_action :find_post, only: %i(edit update destroy verify)
  before_action :check_post_author_permission, only: %i(edit update)
  before_action :check_group_owner_permission, only: %i(verify)

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.group = @group
    @post.author = current_user

    if @post.save
      @post.submit! if params[:commit] == "Submit"
      redirect_to group_path(@group)
    else
      render "new"
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      @post.submit! if params[:commit].in?(%w[Submit Update])
      redirect_to group_path(@group), notice: "Update Success"
    else
      render "edit"
    end
  end

  def destroy
    case params[:commit]
    when "cancel"
      return redirect_to root_path, alert: "You have no permission." if current_user != @post.author
      @post.cancel!
    when "block"
      return redirect_to root_path, alert: "You have no permission." if current_user != @group.owner
      @post.block!
    end

    redirect_to group_path(@group), notice: "Group #{params[:commit]}ed"
  end

  def verify
    @post.approve! if params[:commit] == "approve"
    @post.unapprove! if params[:commit] == "unapprove"

    redirect_to group_path(@group), notice: "Post #{params[:commit]} !"
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def check_post_author_permission
    redirect_to root_path, alert: "You have no permission." if current_user != @post.author
  end

  def check_group_owner_permission
    redirect_to root_path, alert: "You have no permission." if current_user != @group.owner
  end
end
