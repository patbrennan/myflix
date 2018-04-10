require "spec_helper"

describe UsersController do

  describe "GET new" do
    it "sets @user variable" do
      get :new
      expect(assigns(:user)).to be_kind_of(User)
    end
  end

  describe "POST create" do
    context "w/valid input" do
      # If using the fabrication gem:
      # before { post: create, user: Fabricate.attributes_for(:user)

      it "saves user to database" do
        post :create, user: { email: "me@me.com", password: "123456", full_name: "Patrick B" }
        expect(User.count).to eq(1)
      end

      it "redirects to login_path" do
        post :create, user: { email: "me@me.com", password: "123456", full_name: "Patrick B" }
        expect(response).to redirect_to login_path
      end
    end

    context "w/invalid input" do
      it "doesn't create user" do
        post :create, user: { password: "123456", full_name: "Patrick B" }
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        post :create, user: { password: "123456", full_name: "Patrick B" }
        expect(response).to render_template :new
      end
    end
  end
end