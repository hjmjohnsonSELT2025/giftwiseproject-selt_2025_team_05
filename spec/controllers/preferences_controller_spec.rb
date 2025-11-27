require 'rails_helper'

RSpec.describe PreferencesController, type: :controller do
  let(:user) { User.create!(email: "user@example.com", password: "password") }
  let(:recipient) { User.create!(email: "recipient@example.com", password: "password") }
  let(:preference) { Preference.create!(user: user, item_name: 'Test Item', cost: 100.00) }
  let(:valid_attributes) { { item_name: 'car', cost: 999.99, notes: 'for Christmas' } }
  let(:event) {Event.create!(name: "Christmas", user: user)}
  let(:unclaimed_item) {Preference.create!(user: recipient, item_name: 'Test Item', cost: 999.99, event: event, on_user_wishlist: true)}
  let(:claimed_item) {Preference.create!(user: recipient, item_name: 'Test Item', cost: 999.99, event: event, giver: user, on_user_wishlist: true)}
  let!(:claimed_item_not_wishlist) {Preference.create!(user: recipient, item_name: 'Test Item', cost: 999.99, event: event, giver: user, on_user_wishlist: false)}

  before do
    sign_in user
  end

  describe 'POST #create_for_someone_else' do
    context 'with valid parameters' do
      it 'creates a new preference with on_user_wishlist == false' do
        expect {
          post :create_for_someone_else, params: { preference: valid_attributes, recipient_id: recipient.id, event_id: event.id}
        }.to change(Preference, :count).by(1)
        created_preference = Preference.last
        expect(created_preference.on_user_wishlist).to eq(false)
      end
      it 'redirects to event index with notice' do
        post :create_for_someone_else, params: { preference: valid_attributes, recipient_id: recipient.id, event_id: event.id}
        expect(response).to redirect_to(event)
        expect(flash[:notice]).to eq("Item added!")
      end
      end
  end

  describe 'GET #new_for_someone_else' do
    context 'with valid parameters' do
      it 'redirects to the "adding to someone else wish list" page with notice' do
        get :new_for_someone_else, params: {recipient_id: recipient.id, event_id: event.id}
        expect(response).to render_template(:new_for_someone_else)
      end
    end
  end

  describe 'POST #create_on_wishlist' do
    context 'with valid parameters' do
      it 'creates a new preference with on_user_wishlist == true' do
        expect {
          post :create_on_wishlist, params: { preference: valid_attributes }
        }.to change(Preference, :count).by(1)
        created_preference = Preference.last
        expect(created_preference.on_user_wishlist).to eq(true)
      end

      it 'redirects to preferences index with notice' do
        post :create_on_wishlist, params: { preference: valid_attributes }
        expect(response).to redirect_to(preferences_path)
        expect(flash[:notice]).to eq('Item added to wish list!')
      end
    end
  end

  describe 'POST #claim_preference' do
    context 'with valid parameters' do
      it 'changes a preference from unclaimed to claimed' do
        post :claim_preference, params: { item_id: unclaimed_item.id, user_id: user.id, event_id: event.id}
        updated_preference = Preference.order(updated_at: :desc).first
        expect(updated_preference.giver).to eq(user)
      end
      it 'redirects to the wish list of the user who will recieve the gift' do
        post :claim_preference, params: { item_id: unclaimed_item.id, user_id: user.id, event_id: event.id}
        expect(response).to redirect_to(view_user_wishlist_preferences_path(event_id: event.id, user_id: recipient))
      end
    end
  end

  describe 'POST #unclaim_preference' do
    context 'with valid parameters' do
      it 'changes a preference from claimed to unclaimed' do
        post :unclaim_preference, params: { item_id: claimed_item.id, user_id: user.id, event_id: event.id}
        updated_preference = Preference.order(updated_at: :desc).first
        expect(updated_preference.giver).to eq(nil)
      end
      it 'redirects to the wish list of the user who will receive the gift' do
        post :unclaim_preference, params: { item_id: claimed_item.id, user_id: user.id, event_id: event.id}
        expect(response).to redirect_to(view_user_wishlist_preferences_path(event_id: event.id, user_id: recipient))
      end
      it 'deletes an unclaimed preference from the database if the preference is not on user wish list' do
        expect {
        post :unclaim_preference, params: { item_id: claimed_item_not_wishlist.id, user_id: user.id, event_id: event.id}
        }.to change(Preference, :count).by(-1)
      end
    end
  end

  describe 'POST #unclaim_show_preference' do
    context 'with valid parameters' do
      it 'changes a preference from claimed to unclaimed' do
        post :unclaim_show_preference, params: { item_id: claimed_item.id, user_id: user.id, event_id: event.id}
        updated_preference = Preference.order(updated_at: :desc).first
        expect(updated_preference.giver).to eq(nil)
      end
      it 'redirects to the event index page' do
        post :unclaim_show_preference, params: { item_id: claimed_item.id, user_id: user.id, event_id: event.id}
        expect(response).to redirect_to(event)
      end
      it 'deletes an unclaimed preference from the database if the preference is not on user wish list' do
        expect {
          post :unclaim_show_preference, params: { item_id: claimed_item_not_wishlist.id, user_id: user.id, event_id: event.id}
        }.to change(Preference, :count).by(-1)
      end
    end
  end

  describe 'POST #toggle_purchase' do
    context 'with valid parameters' do
      it 'changes a preference from unpurchased to purchased' do
        post :toggle_purchase, params: {id: claimed_item.id, preference: {purchased: claimed_item.purchased}}
        updated_preference = Preference.order(updated_at: :desc).first
        expect(updated_preference.purchased).to eq(false)
      end
      it 'redirects to the wish list of the user who will receive the gift' do
        post :toggle_purchase, params: {id: claimed_item.id, preference: {purchased: claimed_item.purchased}}
        updated_preference = Preference.order(updated_at: :desc).first
        expect(response).to redirect_to(view_user_wishlist_preferences_path(event_id: updated_preference.event.id, user_id: updated_preference.user.id))
      end
    end
  end

  describe 'POST #toggle_purchase_show' do
    context 'with valid parameters' do
      it 'changes a preference from unpurchased to purchased' do
        post :toggle_purchase_show, params: {id: claimed_item.id, preference: {purchased: claimed_item.purchased}}
        updated_preference = Preference.order(updated_at: :desc).first
        expect(updated_preference.purchased).to eq(false)
      end
      it 'redirects to the event index page' do
        post :toggle_purchase_show, params: {id: claimed_item.id, preference: {purchased: claimed_item.purchased}}
        updated_preference = Preference.order(updated_at: :desc).first
        expect(response).to redirect_to(updated_preference.event)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the requested preference' do
        patch :update, params: { id: preference.id, preference: { item_name: 'Updated Item' } }
        preference.reload
        expect(preference.item_name).to eq('Updated Item')
      end

      it 'redirects to preferences index with notice' do
        patch :update, params: { id: preference.id, preference: valid_attributes }
        expect(response).to redirect_to(preferences_path)
        expect(flash[:notice]).to eq('Item updated successfully!')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested preference' do
      preference # Create the preference
      expect {
        delete :destroy, params: { id: preference.id }
      }.to change(Preference, :count).by(-1)
    end

    it 'redirects to preferences index with notice' do
      delete :destroy, params: { id: preference.id }
      expect(response).to redirect_to(preferences_path)
      expect(flash[:notice]).to eq('Item removed from wish list')
    end
  end
end