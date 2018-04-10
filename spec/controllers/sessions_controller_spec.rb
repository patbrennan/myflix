require "spec_helper"

describe SessionsController do

  describe "GET new" do
    it "sets @user variable" do
      get :new
      expect(assigns(:user)).to be_kind_of(User)
    end
  end

  describe "POST create" do
    context "successful login" do
      let(:user) { User.create(email: Faker::Internet.email, password: "123456", full_name: Faker::Name.name) }

      it "sets the session[:user_id]" do
        post :create, email: user.email, password: "123456"
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to home_path" do
        post :create, email: user.email, password: "123456"
        expect(response).to redirect_to home_path
      end
    end


    context "UNsuccessful login attempt" do
      let(:user) { User.create(email: Faker::Internet.email, password: "123456", full_name: Faker::Name.name) }

      it "renders :new template with unsuccessful login" do
        post :create, email: user.email, password: "not_the_password"
        expect(response).to render_template :new
      end

      it "does NOT set session[:user_id] with unsuccessful login" do
        post :create, email: user.email, password: "not_the_password"
        expect(session[:user_id]).to eq(nil)
      end
    end
  end

  describe "GET destory" do
    it "sets session[:user_id] to nil" do
      user = User.create(email: Faker::Internet.email, password: "123456", full_name: Faker::Name.name)
      session[:user_id] = user.id

      get :destroy
      expect(session[:user_id]).to eq(nil)
    end

    it "redirects to login_path" do
      get :destroy
      expect(response).to redirect_to login_path
    end
  end
end