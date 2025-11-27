require 'rails_helper'

RSpec.describe PreferencesController, type: :controller do
  let(:user) { User.create!(email: "user@example.com", password: "password") }
  let(:preference) { Preference.create!(user: user, item_name: 'Test Item', cost: 100.00) }
  let(:valid_attributes) { { item_name: 'car', cost: 999.99, notes: 'for Christmas' } }

  before do
    sign_in user
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