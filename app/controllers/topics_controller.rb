class TopicsController < ApplicationController

  before_action :set_topic, :only => [:show, :edit, :update, :destroy, :favorite, :unfavorite]
  before_action :authenticate_user!, :except => [:index, :show]

  #GET topics/
  def index
    @topics = Topic.all

    if params[:Category]
      @topics = Category.find(params[:Category]).topics
    end

    if params[:order]
      if params[:order] == "updated_at"
        sort_by = "updated_at"
      elsif params[:order] == "comments_count"
        sort_by = "comments_count"
      elsif params[:order] == "views_count"
        sort_by = "views_count"
      else
        sort_by = "id"
      end
      @topics = @topics.order("#{sort_by} DESC")
    end

    @topics = @topics.page( params[:page] ).per(10)
  end

  #GET topics/new
  def new
    @topic = Topic.new
  end

  #POST topics/
  def create
    @topic = Topic.new(topic_params)
    @topic.user = current_user
    if @topic.save
      flash[:notice] = "Created successfully!!"
      redirect_to topics_path
    else
      render :action => :new
    end
  end

  #GET topic/:id
  def show
    #計數連結被點次數
    @topic.views_count += 1
    @topic.save

    @comments = @topic.comments.page(params[:page]).per(6)
    @comment = @topic.comments.build
  end

  #GET topics/about
  def about
  end

  #GET topics/user/profile
  def user_profile
  end

  #GET topic/:id/edit
  def edit
    unless current_user.author?(@topic)
      flash[:alert] = "You are not author!!"
      redirect_to topics_path
    end
  end

  #PATCH topic/:id
  def update
    if @topic.update(topic_params)
      flash[:notice] = "Edited successfully!!"
      redirect_to topics_path
    else
      render :action => :edit
    end
  end

  #DELETE topic/:id
  def destroy
    if current_user.author?(@topic)
      @topic.destroy
      flash[:alert] = "Deleted successfully !!"
    else
      flash[:alert] = "You are not author!!"
    end
    redirect_to topics_path
  end

  def favorite
    @favorite = @topic.find_my_favorite(current_user)
    unless @favorite
      @favorite = FavoriteTopic.create!(:topic => @topic, :user => current_user)
    end
    redirect_to :back
  end

  def unfavorite
    @favorite = @topic.find_my_favorite(current_user)
    @favorite.destroy if @favorite
    redirect_to :back
  end

  #以下為controller內部使用的method
  protected

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:name, :description, :category_ids => [])
  end

end
