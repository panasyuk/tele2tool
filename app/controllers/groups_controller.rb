class GroupsController < ApplicationController

  def new
    @group = Group.new
  end

  def create
    @group = Group.new group_params
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find params[:id]
    @posts = @group.posts.where('published_at BETWEEN ? AND ?', date_from, date_to)
    @likes_count = @posts.likes_count
    @comments_count = @posts.comments_count
    @reposts_count = @posts.reposts_count
    @posts = @posts.order('published_at DESC').page params[:page]
  end

  def destroy
    @group = Group.find params[:id]
    @group.destroy
    redirect_to :back
  end

  private

    def group_params
      params.require(:group).permit(:url)
    end

end
