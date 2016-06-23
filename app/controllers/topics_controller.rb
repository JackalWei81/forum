class TopicsController < ApplicationController

  before_action :set_topic, :only => [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:index, :show]

  #GET topics/
  def index
    @topics = Topic.all
    if params[:order]
      if params[:order] == "updated_at"
        sort_by = "updated_at"
      elsif params[:order] == "comments_count"
        sort_by = "comments_count"
      end
      @topics = @topics.all.order("#{sort_by} DESC")
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
    if @topic.save
      flash[:notice] = "Created successfully!!"
      redirect_to topics_path
    else
      render :action => :new
    end
  end

  #GET topic/:id
  def show
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
    @topic.destroy
    flash[:alert] = "Deleted successfully !!"
    redirect_to topics_path
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
