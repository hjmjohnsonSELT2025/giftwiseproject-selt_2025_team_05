require 'rails_helper'

RSpec.describe EventUsersController, type: :controller do
  let(:owner) { User.create!(email: "owner@example.com", password: "password", first_name: "Owner", last_name: "User") }
  let(:guest) { User.create!(email: "guest@example.com", password: "password", first_name: "Guest", last_name: "User") }

  # UPDATED: Changed event_type from "public" to "friend"
  let(:event) { owner.events.create!(name: "Party", date: Date.tomorrow, address: "123 Main St", description: "Fun", event_type: "friend") }

  let!(:event_user_guest) { EventUser.create!(event: event, user: guest, status: :invited) }

  describe "POST #create (Invite)" do
    before { sign_in owner }

    context "when owner invites a user" do
      let(:new_user) { User.create!(email: "new@example.com", password: "password", first_name: "New", last_name: "Person") }

      it "creates a new event_user with invited status" do
        expect {
          post :create, params: { event_id: event.id, user_id: new_user.id }
        }.to change(EventUser, :count).by(1)

        expect(EventUser.last.status).to eq("invited")
      end

      it "redirects to event page with notice" do
        post :create, params: { event_id: event.id, user_id: new_user.id }
        expect(response).to redirect_to(event)
        expect(flash[:notice]).to include("invited")
      end
    end

    context "when non-owner tries to invite" do
      before { sign_in guest }

      it "does not create event_user" do
        new_user = User.create!(email: "new@example.com", password: "password")
        expect {
          post :create, params: { event_id: event.id, user_id: new_user.id }
        }.not_to change(EventUser, :count)
      end

      it "redirects with alert" do
        new_user = User.create!(email: "new@example.com", password: "password")
        post :create, params: { event_id: event.id, user_id: new_user.id }
        expect(response).to redirect_to(event)
        expect(flash[:alert]).to include("not authorized")
      end
    end
  end

  describe "PATCH #update" do
    context "as the guest user (self actions)" do
      before { sign_in guest }

      it "allows accepting an invite (joined)" do
        patch :update, params: { event_id: event.id, id: event_user_guest.id, status: 'joined' }
        event_user_guest.reload
        expect(event_user_guest.status).to eq("joined")
        expect(flash[:notice]).to include("successfully joined")
      end

      it "allows declining an invite (declined)" do
        patch :update, params: { event_id: event.id, id: event_user_guest.id, status: 'declined' }
        event_user_guest.reload
        expect(event_user_guest.status).to eq("declined")
        expect(flash[:notice]).to include("declined")
      end

      it "allows leaving the event (left)" do
        event_user_guest.update(status: :joined) # Pre-condition
        patch :update, params: { event_id: event.id, id: event_user_guest.id, status: 'left' }
        event_user_guest.reload
        expect(event_user_guest.status).to eq("left")
        expect(flash[:notice]).to include("left the event")
      end

      it "rejects invalid statuses" do
        patch :update, params: { event_id: event.id, id: event_user_guest.id, status: 'random_status' }
        event_user_guest.reload
        expect(event_user_guest.status).to eq("invited") # Should not change
        expect(flash[:alert]).to include("Invalid status")
      end
    end

    context "as the event owner" do
      before { sign_in owner }

      # We need an event_user record for the owner themselves
      let!(:event_user_owner) { EventUser.create!(event: event, user: owner, status: :joined) }

      it "prevents owner from leaving their own event" do
        patch :update, params: { event_id: event.id, id: event_user_owner.id, status: 'left' }
        event_user_owner.reload
        expect(event_user_owner.status).to eq("joined")
        expect(flash[:alert]).to include("cannot leave your own event")
      end

      it "allows owner to remove a participant (set to left)" do
        # Owner removing Guest
        patch :update, params: { event_id: event.id, id: event_user_guest.id, status: 'left' }
        event_user_guest.reload
        expect(event_user_guest.status).to eq("left")
        expect(flash[:notice]).to include("removed")
      end

      it "prevents owner from setting other statuses on participants (e.g., declined)" do
        # Owner trying to set Guest to declined (not allowed, only 'left')
        patch :update, params: { event_id: event.id, id: event_user_guest.id, status: 'declined' }
        event_user_guest.reload
        expect(event_user_guest.status).not_to eq("declined")
        expect(flash[:alert]).to include("can only remove participants")
      end
    end

    context "unauthorized actions" do
      let(:stranger) { User.create!(email: "stranger@example.com", password: "password") }
      before { sign_in stranger }

      it "prevents a user from updating someone else's status" do
        patch :update, params: { event_id: event.id, id: event_user_guest.id, status: 'joined' }
        event_user_guest.reload
        expect(event_user_guest.status).to eq("invited")
        expect(flash[:alert]).to include("not authorized")
      end
    end
  end
end