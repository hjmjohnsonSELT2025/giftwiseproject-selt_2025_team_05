require "rails_helper"

RSpec.describe "User login", type: :request do
  let!(:user) { User.create!(email: "dummy@example.com", password: "123456") }

  it "forces unauthenticated visitors to log in" do
    get root_path
    expect(response).to redirect_to(new_user_session_path)
    follow_redirect!
    expect(response.body).to include("You need to sign in or sign up before continuing.")
  end

  it "signs in with valid credentials" do
    post user_session_path, params: { user: { email: user.email, password: "123456" } }

    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(controller.current_user).to eq(user)

    expect(response.body).to include("Signed in successfully."), "Flash did not include the success message"
  end

  it "rejects invalid credentials" do
    post user_session_path, params: { user: { email: user.email, password: "654321" } }

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("Invalid Email or password."), "Error flash missing for invalid login"
  end
end