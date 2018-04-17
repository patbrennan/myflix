require "spec_helper"

describe QItemsController do

  describe "GET index" do
    context "with authenticated user" do
      let(:user) { User.create(email: Faker::Internet.email, password: "password", full_name: Faker::Name.name) }
      let(:cat1) { Category.create(name: "Horror") }
      let(:cat2) { Category.create(name: "Comedy") }
      let(:vid1) { Video.create(title: Faker::Book.name, description: Faker::Lorem.paragraph, category_id: cat1.id) }
      let(:vid2) { Video.create(title: Faker::Book.name, description: Faker::Lorem.paragraph, category_id: cat2.id) }
      let(:q1) { QItem.create(user_id: user.id, video_id: vid1.id, position: 1) }
      let(:q2) { QItem.create(user_id: user.id, video_id: vid2.id, position: 2) }

      before { session[:user_id] = user.id }

      it "renders index template" do
        get :index
        expect(response).to render_template :index
      end

      it "sets @q_items to q items of logged in user" do
        get :index
        expect(assigns(:q_items)).to match_array([q1, q2])
      end
    end

    context "NO authentication" do
      it "redirects to login page" do
        get :index
        expect(response).to redirect_to login_path
      end
    end
  end
end
