class PreferencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_preference, only: [ :edit, :update, :destroy ]

  def index
    @preferences = current_user.preferences.order(created_at: :desc)
  end

  def new
    @preference = Preference.new
  end

  def create
    @preference = Preference.new(preference_params)
    @preference.user = current_user

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