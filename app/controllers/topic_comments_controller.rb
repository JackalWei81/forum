class TopicCommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_topic

  def create
    @comment = @topic.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Created successfully!!"
    else
      flash[:alert] = "Created failure!!"
    end
    redirect_to topic_path(@topic)
  end

  def update
    @comment = @topic.comments.find(params[:id])
    if params[:remove_image] == "1"
      @comment.avatar = nil
    end
    if @comment.update(comment_params)
      flash[:notice] = "Edited successfully!!"
      redirect_to topic_path(@topic)
    else
      flash[:alert] = "Edited failure!!"
      render :action => :edit
    end
  end

  def destroy
    @comment = @topic.comments.find(params[:id])
    if current_user.is_author?(@comment) || current_user.is_admin?
      @comment.destroy
      respond_to do |format|
        format.html {
          flash[:alert] = "Delete successfully!!"
          redirect_to topic_path(@topic)
        }
        format.js #destroy.js.erb
      end
    else
      flash[:alert] = "You are not author!!"
      redirect_to topic_path(@topic)
    end
  end


  #topic_comments內部使用的method
  protected
  def set_topic
    @topic = Topic.find(params[:topic_id])
  end

  def comment_params
    params.require(:comment).permit(:name, :avatar, :status)
  end

end
