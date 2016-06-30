class ProfilesController < ApplicationController

  before_action :set_profile, :only => [:show, :edit, :update]

  #不做刪除，也不做個人簡介必填，因為空白代表清空。
  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      flash[:notice] = "Created successfully!!"
      redirect_to profile_path(@profile)
    else
      render :action => :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      flash[:notice] = "Edited successfully!!"
      redirect_to profile_path(@profile)
    else
      render :action => :edit
    end
  end


  #profile內部使用method
  protected
  def profile_params
    params.require(:profile).permit(:bio)
  end

  def set_profile
    #設定傳入參數為short_name,再傳過來後經過轉換轉回:id，即可繼續原本操作
    user = User.where(["email like ?", "%#{params[:id]}@%"]).first
    @profile = Profile.find(user)
  end

end
