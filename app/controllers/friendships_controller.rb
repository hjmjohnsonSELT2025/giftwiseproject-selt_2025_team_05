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
    @friendship = current_user.received_friendships.find(params[:id])

    if params[:status] == "accepted"
      @friendship.accepted!
      message = "Friend request accepted!"
    else
      @friendship.declined!
      message = "Friend request declined."
    end

    redirect_back fallback_location: root_path, notice: message
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
