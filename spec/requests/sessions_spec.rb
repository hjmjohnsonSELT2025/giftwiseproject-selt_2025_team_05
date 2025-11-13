require "rails_helper"

RSpec.describe "Authentication", type: :request do
  let!(:user) { User.create!(email: "dummy@example.com", password: "123456") }

  describe "DELETE /users/sign_out" do
    before do
      post user_session_path, params: { user: { email: user.email, password: "123456" } }
      follow_redirect!
    end

    it "signs the user out and redirects to the login page" do
      delete destroy_user_session_path

      expect(response).to redirect_to(root_path)
      follow_redirect!

      expect(response).to redirect_to(new_user_session_path)
      follow_redirect!
      expect(response.body).to include("You need to sign in or sign up before continuing.")
    end
  end
end