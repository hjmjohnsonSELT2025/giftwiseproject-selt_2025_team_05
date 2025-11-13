class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @friendship = current_user.sent_friendships.new(friend_id: params[:friend_id])

    if @friendship.save
      redirect_back fallback_location: root_path, notice: "Friend request sent!"
    else
      redirect_back fallback_location: root_path, alert: "Unable to send friend request."
    end
  end

  def update
    @friendship = Friendship.find(params[:id])

    # Only allow valid statuses
    if Friendship.statuses.key?(params[:status])
      @friendship.update(status: params[:status])
    end

    redirect_to root_path
  end



  def destroy
    @friendship = Friendship.find(params[:id])

    # Only allow sender or receiver to delete the relationship
    if @friendship.user == current_user || @friendship.friend == current_user
      @friendship.destroy
      redirect_back fallback_location: root_path, notice: "Friend removed."
    else
      redirect_back fallback_location: root_path, alert: "Not authorized to remove this friendship."
    end
  end
end
