#Home controller source: https://www.digitalocean.com/community/tutorials/how-to-set-up-user-authentication-with-devise-in-a-rails-7-application
class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @upcoming_events = current_user.event_users
                                   .includes(:event)
                                   .where(status: :joined)
                                   .where("events.deleted = ? AND events.date >= ?", false, Date.today)
                                   .references(:event)
                                   .order("events.date")
  end
end