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

  describe "should make the user wait to authenticate" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    it "executes the inactive sign up redirect method" do
      path = controller.send(:after_inactive_sign_up_path_for, user)
      expect(path).to eq(controller.send(:after_sign_up_path_for, user))
    end
  end


  describe "GET #new" do
    before { @request.env["devise.mapping"] = Devise.mappings[:user] }
    it "renders the new registration form" do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
    it "assigns the current user" do
      get :show
      expect(assigns(:user)).to eq(user)
      #expect(assigns(:resource)).to eq(user)       #Devise::RegistrationsController does not assign :resource on /GET #show
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #edit" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
    it "renders the edit page" do
      get :edit
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
    it "deletes the user" do
      expect{delete :destroy}.to change(User, :count).by(-1)
    end
  end

  #describe "GET #cancel" do    #I'm having trouble with getting this covered because there is no controller action that uses this
  #end


end
