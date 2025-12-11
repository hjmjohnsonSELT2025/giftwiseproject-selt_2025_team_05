class FriendGiftsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friend = User.find(params[:id])
    @upcoming_gifts, @past_gifts = current_user.gift_history_with(@friend)
  end

end
