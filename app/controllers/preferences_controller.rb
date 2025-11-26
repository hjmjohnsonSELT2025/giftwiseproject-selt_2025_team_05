class PreferencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_preference, only: [ :edit, :update, :destroy ]

  def claim_preference
    @item = Preference.find(params[:item_id])
    @item.giver = User.find(params[:user_id])
    if @item.save
      redirect_to view_user_wishlist_preferences_path(user_id: @item.user_id), notice: "Gift claimed successfully!"
    else
      redirect_to view_user_wishlist_preferences_path(user_id: @item.user_id), alert: "Could not claim gift."
    end
  end

  def view_user_wishlist
    @user = User.find(params[:user_id])
    @preferences = @user.preferences
  end

  def index
    #@preferences = current_user.preferences.order(created_at: :desc)
    @preferences = current_user.preferences.where(on_user_wishlist: true).order(created_at: :desc)
  end


  def new
    @preference = Preference.new
  end

  def create_on_wishlist
    @preference = Preference.new(preference_params)
    @preference.user = current_user
    @preference.on_user_wishlist = true

    if @preference.save
      redirect_to preferences_path, notice: "Item added to wish list!"
    else
      render :new
    end
  end

  def create
    @preference = Preference.new(preference_params)
    @preference.user = current_user
    @preference.on_user_wishlist = false

    if @preference.save
      redirect_to preferences_path, notice: "Item added to wish list!"
    else
      render :new
    end
  end

  def edit
    # @preference is set by set_preference before_action
  end

  def update
    if @preference.update(preference_params)
      redirect_to preferences_path, notice: "Item updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @preference.destroy
    redirect_to preferences_path, notice: "Item removed from wish list"
  end

  private

  def set_preference
    @preference = current_user.preferences.find(params[:id])
  end

  def preference_params
    params.require(:preference).permit(:item_name, :cost, :notes)
  end
end
