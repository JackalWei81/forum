class TopicsController < ApplicationController

  before_action :set_topic, :only => [:show, :edit, :update, :destroy]

  #GET topics/
  def index
    @topics = Topic.all
  end

  #GET topics/new
  def new
    @topic = Topic.new
  end

  #POST topics/
  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      flash[:notice] = "New Success!!"
      redirect_to topics_path
    else
      render :action => :new
    end
  end

  #GET topic/:id
  def show
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
    flash[:alert] = "successfully deleted!!"
    redirect_to topics_path
  end


  #以下為controller內部使用的method
  protected

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:name, :description)
  end

end
