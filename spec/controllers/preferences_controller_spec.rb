require 'rails_helper'

RSpec.describe PreferencesController, type: :controller do
  let(:user) { User.create!(email: "user@example.com", password: "password") }
  let(:recipient) { User.create!(email: "recipient@example.com", password: "password") }
  let(:preference) { Preference.create!(user: user, item_name: 'Test Item', cost: 100.00) }
  let(:valid_attributes) { { item_name: 'car', cost: 999.99, notes: 'for Christmas' } }
  let(:event) {Event.create!(name: "Christmas", user: user)}
  let(:unclaimed_item) {Preference.create!(user: recipient, item_name: 'Test Item', cost: 999.99, event: event)}
  let(:claimed_item) {Preference.create!(user: recipient, item_name: 'Test Item', cost: 999.99, event: event, giver: user)}
  let!(:claimed_item_not_wishlist) {Preference.create!(user: recipient, item_name: 'Test Item', cost: 999.99, event: event, giver: user)}

  before do
    sign_in user
  end

  describe 'GET #view_user_wishlist' do
    it 'returns user preferences' do
      get :view_user_wishlist, params: { user_id: user.id, event_id: event.id }
      expect(assigns(:preferences)).to eq(user.preferences) #this line's syntax from ChatGPT
    end
  end


  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new preference' do
        expect {
          post :create, params: { preference: valid_attributes }
        }.to change(Preference, :count).by(1)
        created_preference = Preference.last
      end

      it 'redirects to preferences index with notice' do
        post :create, params: { preference: valid_attributes }
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
      it 'redirects to the wish list of the user who will receive the gift' do
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
      it 'redirects to the wish list of the user who will receive the gift with redirect: wishlist' do
        post :unclaim_preference, params: { item_id: claimed_item.id, user_id: user.id, event_id: event.id, redirect: "wishlist"}
        expect(response).to redirect_to(view_user_wishlist_preferences_path(event_id: event.id, user_id: recipient))
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
      it 'redirects to the user gift summary page of the user who will receive the gift with redirect: user_gift_summary' do
        post :toggle_purchase, params: {id: claimed_item.id, preference: {purchased: claimed_item.purchased}, redirect: "user_gift_summary"}
        updated_preference = Preference.order(updated_at: :desc).first
        expect(response).to redirect_to(user_gift_summary_path(event_id: updated_preference.event.id, user_id: updated_preference.user.id))
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