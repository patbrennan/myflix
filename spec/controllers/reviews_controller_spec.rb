require "spec_helper"

describe ReviewsController do
  describe "POST create" do
    context "Authenticated User" do
      let(:user) { User.create(email: Faker::Internet.email, password: "password", full_name: Faker::Name.name) }
      let(:video) { Video.create(title: "Ghostbusters", description: Faker::Lorem.paragraph) }
      before { session[:user_id] = user.id }

      it "saves a review to the database with all req'd params" do
        post :create, review: { rating: 5, description: "Description" }, video_id: video.id, user_id: user.id
        expect(Review.all.size).to eq(1)
      end

      it "renders 'videos/show' template with missing description & doesn't save to database" do
        post :create, review: { rating: 4 }, video_id: video.id, user_id: user.id

        expect(Review.all.size).to eq(0)
        expect(response).to render_template "videos/show"
      end

      it "sets the @reviews variable w/missing description" do
        post :create, review: { rating: 4 }, video_id: video.id, user_id: user.id

        expect(assigns(:reviews)).to eq(video.reviews)
      end
    end

    context "No user authenticated" do
      let(:video) { Video.create(title: "Ghostbusters", description: Faker::Lorem.paragraph) }

      it "doesn't save to database" do
        post :create, review: { rating: 4, description: "random" }, video_id: video.id, user_id: 1
        expect(Review.count).to eq(0)
      end

      it "redirects to login_path" do
        post :create, review: { rating: 4, description: "random" }, video_id: video.id, user_id: 1
        expect(response).to redirect_to login_path
      end
    end
  end
end