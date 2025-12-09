require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { User.create!(email: "owner@example.com", password: "password", first_name: "Owner", last_name: "User") }
  let(:other_user) { User.create!(email: "other@example.com", password: "password", first_name: "Other", last_name: "User") }
  let(:friend) { User.create!(email: "friend@example.com", password: "password", first_name: "Best", last_name: "Friend") }

  # Ensure event_type matches your valid Enum/String values
  let(:event) { user.events.create!(name: "Conference", date: Date.tomorrow, address: "City Hall", description: "Annual event", event_type: "friend") }

  before do
    sign_in user
    # Create the actual friendship in the DB so current_user.all_friends finds it naturally
    Friendship.create!(user: user, friend: friend, status: 'accepted')
    Friendship.create!(user: friend, friend: user, status: 'accepted')
  end

  describe "GET #new" do
    it "assigns a new event" do
      get :new
      expect(assigns(:event)).to be_a_new(Event)
    end

    it "assigns @friends for the checkbox list" do
      get :new
      expect(assigns(:friends)).to include(friend)
    end
  end

  describe "GET #show" do
    let!(:potential_guest) { User.create!(email: "guest@example.com", password: "password", first_name: "John", last_name: "Doe") }

    context "when owner views the page (Default / Empty Query)" do
      it "assigns @found_users to the friends list by default" do
        get :show, params: { id: event.id }
        expect(assigns(:found_users)).to include(friend)
      end

      it "does not show friends who are already participants" do
        EventUser.create!(event: event, user: friend, status: :invited)
        get :show, params: { id: event.id }
        expect(assigns(:found_users)).not_to include(friend)
      end
    end

    context "when owner searches for a user" do
      it "assigns @found_users with matching results" do
        get :show, params: { id: event.id, query: "John" }
        expect(assigns(:found_users)).to include(potential_guest)
      end

      it "does not return users who are already joined" do
        EventUser.create!(event: event, user: potential_guest, status: :joined)
        get :show, params: { id: event.id, query: "John" }
        expect(assigns(:found_users)).to be_empty
      end
    end

    context "when non-owner tries to search" do
      before { sign_in other_user }

      it "does not assign @found_users even with query" do
        get :show, params: { id: event.id, query: "John" }
        expect(assigns(:found_users)).to be_nil
      end
    end

    context "when event is deleted" do
      before do
        event.update_columns(deleted: true)
      end

      it "redirects to root path with alert" do
        get :show, params: { id: event.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include("deleted")
      end
    end
  end

  describe "POST #create" do
    let(:valid_attributes) {
      { name: "New Event", date: Date.tomorrow, address: "City Hall", description: "Desc", event_type: "friend" }
    }

    context "with valid params" do
      it "creates a new event" do
        expect {
          post :create, params: { event: valid_attributes }
        }.to change(Event, :count).by(1)
      end

      it "creates an initial event_user record with joined status for host" do
        post :create, params: { event: valid_attributes }
        expect(EventUser.last.status).to eq("joined")
        expect(EventUser.last.user).to eq(user)
      end

      it "redirects to the event show page" do
        post :create, params: { event: valid_attributes }
        expect(response).to redirect_to(assigns(:event))
      end
    end

    context "with participants (Inviting Friends)" do
      it "creates invited EventUser records for selected friends" do
        expect {
          post :create, params: {
            event: valid_attributes,
            participant_ids: [friend.id]
          }
        }.to change(EventUser, :count).by(2) # 1 Host (Joined) + 1 Friend (Invited)

        # Verify the friend's status
        friend_invite = EventUser.find_by(user: friend)
        expect(friend_invite.status).to eq("invited")
        expect(friend_invite.event).to eq(Event.last)
      end
    end

    context "with invalid params" do
      it "reloads @friends and re-renders new template" do
        # Invalid because name is missing
        post :create, params: { event: { name: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
        # Critical: Ensure friends list is present for the re-rendered form
        expect(assigns(:friends)).to include(friend)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response for owner" do
      get :edit, params: { id: event.id }
      expect(response).to be_successful
    end

    it "redirects non-owners" do
      sign_in other_user
      get :edit, params: { id: event.id }
      expect(response).to redirect_to(events_path)
      expect(flash[:alert]).to include("not authorized")
    end
  end

  describe "PATCH #update" do
    it "updates the event attributes" do
      patch :update, params: { id: event.id, event: { name: "Updated Name" } }
      event.reload
      expect(event.name).to eq("Updated Name")
    end

    it "redirects to the show page after update" do
      patch :update, params: { id: event.id, event: { name: "Updated Name" } }
      expect(response).to redirect_to(event)
    end
  end

  describe "DELETE #destroy" do
    it "marks the event as deleted" do
      delete :destroy, params: { id: event.id }
      event.reload
      expect(event.deleted).to be true
    end

    it "updates all event_users statuses to left" do
      EventUser.create!(event: event, user: other_user, status: :joined)

      delete :destroy, params: { id: event.id }
      expect(EventUser.where(event: event).pluck(:status)).to all(eq("left"))
    end

    it "redirects to root with a notice" do
      delete :destroy, params: { id: event.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Event deleted successfully.")
    end

    it "prevents non-owners from deleting the event" do
      sign_in other_user
      delete :destroy, params: { id: event.id }
      event.reload
      expect(event.deleted).to be_falsey
      expect(response).to redirect_to(events_path)
    end
  end

  describe "GET #clone" do
    let!(:source_event) do
      user.events.create!(
        name: "Original Event",
        date: 1.week.from_now,
        address: "123 Main St",
        description: "Original description",
        event_type: "family"
      )
    end

    before do
      # Add participants to the source event
      EventUser.create!(event: source_event, user: user, status: :joined)
      EventUser.create!(event: source_event, user: friend, status: :joined)
    end

    it "renders the new event template" do
      get :clone, params: { id: source_event.id }
      expect(response).to render_template(:new)
    end

    it "assigns a new event with cloned name" do
      get :clone, params: { id: source_event.id }
      expect(assigns(:event).name).to eq("Original Event (Clone)")
    end

    it "copies the address from source event" do
      get :clone, params: { id: source_event.id }
      expect(assigns(:event).address).to eq("123 Main St")
    end

    it "copies the event_type from source event" do
      get :clone, params: { id: source_event.id }
      expect(assigns(:event).event_type).to eq("family")
    end

    it "copies the description from source event" do
      get :clone, params: { id: source_event.id }
      expect(assigns(:event).description).to eq("Original description")
    end

    it "assigns @friends for the checkbox list" do
      get :clone, params: { id: source_event.id }
      expect(assigns(:friends)).to include(friend)
    end

    it "pre-selects participants from source event (excluding owner)" do
      get :clone, params: { id: source_event.id }
      expect(assigns(:selected_participant_ids)).to include(friend.id)
      expect(assigns(:selected_participant_ids)).not_to include(user.id)
    end

    context "date calculation" do
      it "keeps the same date/time for upcoming events" do
        future_date = 2.weeks.from_now
        source_event.update!(date: future_date)

        get :clone, params: { id: source_event.id }
        expect(assigns(:event).date).to be_within(1.second).of(future_date)
      end

      it "updates the year for events from past years" do
        past_date = 1.year.ago.change(month: 6, day: 15, hour: 14, min: 30)
        source_event.update_column(:date, past_date)

        get :clone, params: { id: source_event.id }

        cloned_date = assigns(:event).date
        expect(cloned_date.year).to eq(Time.current.year)
        expect(cloned_date.month).to eq(6)
        expect(cloned_date.day).to eq(15)
        expect(cloned_date.hour).to eq(14)
        expect(cloned_date.min).to eq(30)
      end

      it "advances to next month for past events in current year" do
        # Create a date that's definitely in the past this year
        past_date = 2.months.ago.change(day: 15, hour: 10, min: 0)
        source_event.update_column(:date, past_date)

        get :clone, params: { id: source_event.id }

        cloned_date = assigns(:event).date
        expect(cloned_date).to be >= Time.current
        expect(cloned_date.day).to eq(15)
        expect(cloned_date.hour).to eq(10)
      end
    end

    context "when user is not the owner" do
      before { sign_in other_user }

      it "still allows cloning (creates their own copy)" do
        get :clone, params: { id: source_event.id }
        expect(response).to render_template(:new)
        expect(assigns(:event).name).to eq("Original Event (Clone)")
      end
    end
  end
end