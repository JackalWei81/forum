class FriendshipsController < ApplicationController

  def create
    @user = User.find(params[:id])
    @friendship = @user.friendships.build(:friend_id => params[:friend_id])
    @friendship.save ? flash[:notice] = "Added friend" : flash[:alert] = "Unable to add friend"
    redirect_to root_path
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Remove friendship"
    redirect_to root_path
  end

end
