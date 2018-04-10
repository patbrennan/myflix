require 'spec_helper'

describe VideosController do

  describe "GET show" do
    it "sets @video variable if user authenticated" do
      vid = Video.create(title: Faker::Book.title, description: Faker::Lorem.paragraph)
      user = User.create(email: Faker::Internet.email, password: "123456", full_name: Faker::Name.name)
      session[:user_id] = user.id

      get :show, id: vid.id
      expect(assigns(:video)).to eq(vid)
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