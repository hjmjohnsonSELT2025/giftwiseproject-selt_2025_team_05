require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { User.create!(email: "user@example.com", password: "password", first_name: "First Name", last_name: "Last Name", birthdate: "2022-01-01") }
  describe "editing profile information" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
    it "should change a User's first name to Bob" do
      put :update, params: {user: {first_name: "Bob", current_password: "password"}}
      user.reload
      expect(user.first_name).to eq("Bob")
    end
    it "should not change profile information without correct password confirmation" do
      put :update, params: {user: {first_name: "Bob", current_password: ""}}
      user.reload
      expect(user.first_name).to eq("First Name")
    end
  end
  describe "creating a new user" do

    it "should create a new user with valid information" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, params: {user: {first_name: "Amy", last_name: "Last Name", birthdate: "2022-01-01", password: "password", email: "amy@test.com"}}
      created_user = User.last
      expect(created_user.first_name).to eq("Amy")
      expect(created_user.email).to eq("amy@test.com")
    end
    it "should not create a new user with invalid email" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      expect {post :create, params: {user: {first_name: "", last_name: "Last Name", birthdate: "2022-01-01", password: "password", email: "amy"}}}.not_to change(User, :count)
    end
  end
end
