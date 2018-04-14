require 'spec_helper'

describe VideosController do

  describe "GET show" do
    context "has authenticated user" do
      let(:vid) { Video.create(title: Faker::Book.title, description: Faker::Lorem.paragraph) }
      let(:user) { User.create(email: Faker::Internet.email, password: "123456", full_name: Faker::Name.name) }

      it "sets @video variable if user authenticated" do
        session[:user_id] = user.id

        get :show, id: vid.id
        expect(assigns(:video)).to eq(vid)
      end

      it "sets @video variable if user authenticated" do
        session[:user_id] = user.id

        get :show, id: vid.id
        expect(assigns(:video)).to eq(vid)
      end

      it "sets the @reviews variable" do
        rev1 = Review.create(rating: 4, description: "Some review text", user: user, video: vid)
        rev2 = Review.create(rating: 3, description: "The description of why it's 3", user: user, video: vid)

        expect(vid.reviews) =~ [rev1, rev2] # doesn't have to match order
      end
    end

    it "redirects user to the login page when unauthenticated" do
      vid = Video.create(title: Faker::Book.title, description: Faker::Lorem.paragraph)

      get :show, id: vid.id
      expect(response).to redirect_to login_path
    end
  end

  describe "GET search" do
    it "sets @results variable if user authenticated" do
      vid = Video.create(title: "Futurama", description: Faker::Lorem.paragraph)
      user = User.create(email: Faker::Internet.email, password: "123456", full_name: Faker::Name.name)
      session[:user_id] = user.id

      get :search, query: "rama"
      expect(assigns(:results)).to eq([vid])
    end

    it "redirects user to login when unauthenticated" do
      get :search, query: "Random String"
      expect(response).to redirect_to login_path
    end
  end
end