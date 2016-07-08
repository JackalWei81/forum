class FriendshipsController < ApplicationController

  def create
    @user = User.find(params[:id])
    @friendship = @user.friendships.build(:friend_id => params[:friend_id])
    @friendship.save ? flash[:notice] = "Added friend" : flash[:alert] = "Unable to add friend"
    redirect_to root_path
  end

  def update
    @friendship = Friendship.where(:user_id => params[:friend_id], :friend_id => current_user.id).first

    if @friendship
      @friendship.update!( :confirmed => true )
      @friendship_inverse = Friendship.find_or_create_by(:user_id => current_user.id, :friend_id => params[:friend_id])
      @friendship_inverse.update!(:confirmed => true)
     end
    redirect_to profile_path(current_user.short_name)
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Remove friendship"
    redirect_to profile_path(current_user.short_name)
  end

end
