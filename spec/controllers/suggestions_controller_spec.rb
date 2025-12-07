require 'rails_helper'

RSpec.describe SuggestionsController, type: :controller do
  let(:user) { User.create!(email: "user@example.com", password: "password") }
  let(:recipient) { User.create!(email: "recipient@example.com", password: "password") }
  let(:event) {Event.create!(name: "Christmas", user: user)}
  let(:suggestion) { Suggestion.create!(user: user, item_name: 'Test Item', cost: 100.00, purchased: 0, user: user, recipient: recipient, event: event) }
  let(:valid_attributes) { { item_name: 'car', cost: 999.99, notes: 'for Christmas'} }


  before do
    sign_in user
  end

  describe 'GET #new' do
    context 'with valid parameters' do
      it 'renders new suggestion view' do
        get :new, params: {
          user_id: user.id,
          event_id: event.id
        }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    context 'with valid parameters' do
      it 'redirects to edit suggestion view' do
        get :edit, params: {
          id: suggestion.id,
          redirect: "user_gift_summary"
        }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new suggestion' do
        expect {
          post :create, params: {
            user_id: user.id,
            recipient_id: recipient.id,
            event_id: event.id,
            suggestion: valid_attributes
          } #ChatGPT helped debug params structure
        }.to change(Suggestion, :count).by(1)
        created_suggestion = Suggestion.last
      end

      it 'redirects to user_gift_summary with notice' do
        post :create, params: {
          user_id: user.id,
          recipient_id: recipient.id,
          event_id: event.id,
          suggestion: valid_attributes
        } #ChatGPT helped debug params structure
        expect(response).to redirect_to(user_gift_summary_path(user_id: recipient.id, event_id: event.id))
        expect(flash[:notice]).to eq('Gift suggestion added!')
      end
    end
  end

  describe 'POST #toggle_purchase_suggestion' do
    context 'with valid parameters' do
      it 'changes a suggestion from unpurchased to purchased' do
        post :toggle_purchase_suggestion, params: {id: suggestion.id, suggestion: {purchased: 1}, redirect: "user_gift_summary"}
        updated_preference = Suggestion.order(updated_at: :desc).first
        expect(updated_preference.purchased).to eq(true)
      end
      it 'redirects to the user gift summary page of the user who will receive the gift with redirect: user_gift_summary' do
        post :toggle_purchase_suggestion, params: {id: suggestion.id, suggestion: {purchased: 1}, redirect: "user_gift_summary"}
        updated_preference = Suggestion.order(updated_at: :desc).first
        expect(response).to redirect_to(user_gift_summary_path(event_id: updated_preference.event.id, user_id: updated_preference.recipient.id))
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the requested suggestion' do
        patch :update, params: {
          id: suggestion.id,
          redirect: "event",

          suggestion: {item_name: 'Updated Item',
                       cost: 999.99, notes: 'for Christmas',
                       event_id: event.id,
                       user_id: user.id,}
        }
        suggestion.reload
        expect(suggestion.item_name).to eq('Updated Item')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested suggestion' do
      suggestion # Create the suggestion
      expect {
        delete :destroy, params: { id: suggestion.id }
      }.to change(Suggestion, :count).by(-1)
    end
  end
end