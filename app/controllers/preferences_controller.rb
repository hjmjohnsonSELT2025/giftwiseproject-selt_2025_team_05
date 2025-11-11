class PreferencesController < ApplicationController
  before_action :set_user, only: [:new, :create]

  def new
    @preference = Preference.new
  end

  def create
    @preference = Preference.new(preference_params)
    @preference.user_id = @user.id

    if @preference.save
      redirect_to user_path(@user), notice: 'Item added to wish list!'
    else
      render :new
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def preference_params
    params.require(:preference).permit(:item_name, :cost, :notes)
  end
end