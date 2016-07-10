class TopicsController < ApplicationController

  before_action :set_topic, :only => [:show, :edit, :update, :destroy, :favorite, :unfavorite, :like, :dislike, :subscribe, :unsubscribe]
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
    content_and_tags = topic_params[:description].split("#")
    if content_and_tags.count > 1
      content = content_and_tags.first.strip
      for index in 1..content_and_tags.count-1
        current_user.tag_list.add(content_and_tags[index].strip)
        @topic.tag_list.add(content_and_tags[index].strip)
      end
      current_user.save
    end
    @topic.description = content
    @topic.user = current_user
    if @topic.save
      if params[:photos]
        params[:photos].each { |photo|
          @topic.photos.create(:photo => photo)
        }
      end
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

    @comments = @topic.comments
    if params[:e_id]
      @comment = @topic.comments.find(params[:e_id])
      unless current_user.is_author?(@comment)
        @comment = @topic.comments.build
      end
    else
      @comment = @topic.comments.build
    end
  end

  #GET topics/about
  def about
  end

  #GET topic/:id/edit
  def edit
    unless current_user.is_author?(@topic)
      flash[:alert] = "You are not author!!"
      redirect_to topics_path
    end
  end

  #PATCH topic/:id
  def update

    if params[:remove_image] == "1"
      @topic.avatar.destroy
    end

    if params[:remove_photos] == "1"
      @topic.photos.destroy_all
      if params[:photos]
        params[:photos].each { |photo|
          @topic.photos.create(:photo => photo)
        }
      end
    end

    if @topic.update(topic_params)
      content_and_tags = topic_params[:description].split("#")
      if content_and_tags.count > 1
        content = content_and_tags.first.strip
        for index in 1..content_and_tags.count-1
          current_user.tag_list.add(content_and_tags[index].strip)
          @topic.tag_list.add(content_and_tags[index].strip)
        end
        current_user.save
      end
      @topic.description = content
      @topic.save
      flash[:notice] = "Edited successfully!!"
      redirect_to topics_path
    else
      render :action => :edit
    end
  end

  #DELETE topic/:id
  def destroy
    if current_user.is_author?(@topic) || current_user.is_admin?
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
    respond_to do |format|
      format.html{ redirect_to :back }
      format.js
    end
  end

  def unfavorite
    @favorite = @topic.find_my_favorite(current_user)
    @favorite.destroy if @favorite

    respond_to do |format|
      format.html{ redirect_to :back }
      format.js { render "favorite"}
    end
  end

  def like
    @like = @topic.find_my_like(current_user)
    unless @like
      @like = Like.create!(:topic => @topic, :user => current_user)
    end

    respond_to do |format|
      format.html{ redirect_to :back }
      format.js
    end
  end

  def dislike
    @like = @topic.find_my_like(current_user)
    @like.destroy if @like

    respond_to do |format|
      format.html{ redirect_to :back }
      format.js{ render "like"}
    end
  end

  def subscribe
    @subscribe = @topic.find_my_subscribe(current_user)
    unless @subscribe
      @subscribe = Subscribe.create!(:topic => @topic, :user => current_user)
    end

    respond_to do |format|
      format.html{ redirect_to :back }
      format.js
    end
  end

  def unsubscribe
    @subscribe = @topic.find_my_subscribe(current_user)
    @subscribe.destroy if @subscribe

    respond_to do |format|
      format.html{ redirect_to :back }
      format.js{ render "subscribe"}
    end
  end

  #以下為controller內部使用的method
  protected

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:name, :tag_list, :avatar, :photos, :description,:status, :category_ids => [])
  end

end
