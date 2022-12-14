# frozen_string_literal: true
class GroupsController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update destroy join quit)
  before_action :find_group_and_check_permission, only: %i(edit update destroy)

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user

    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
    else
      render "new"
    end
  end

  def show
    @group = Group.find(params[:id])
    @author_verifying_posts = @group.posts.where(author: current_user, status: %w(pending verifying unapprove)).recent_updated
    @owner_verifying_posts = @group.posts.verifying.recent_updated if current_user == @group.owner
    @once_published_posts = @group.posts.once_published.recent_published.paginate(page: params[:page], per_page: 5)
  end

  def edit; end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "Update Success"
    else
      render "edit"
    end
  end

  def destroy
    @group.destroy

    redirect_to groups_path, alert: "Group deleted"
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本討論版成功！"
    else
      flash[:warning] = "你已经是本討論版成員了！"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本討論版！"
    else
      flash[:warning] = "你不是本討論版成員，怎么退出 XD"
    end

    redirect_to group_path(@group)
  end

  private

  def find_group_and_check_permission
    @group = Group.find(params[:id])

    redirect_to root_path, alert: "You have no permission." if current_user != @group.owner
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
