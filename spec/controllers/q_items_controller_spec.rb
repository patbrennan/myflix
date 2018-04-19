require "spec_helper"

describe QItemsController do

  describe "GET index" do
    context "with authenticated user" do
      let(:user) { User.create(email: Faker::Internet.email, password: "password", full_name: Faker::Name.name) }
      let(:cat1) { Category.create(name: "Horror") }
      let(:cat2) { Category.create(name: "Comedy") }
      let(:vid1) { Video.create(title: Faker::Book.name, description: Faker::Lorem.sentence, category_id: cat1.id) }
      let(:vid2) { Video.create(title: Faker::Book.name, description: Faker::Lorem.sentence, category_id: cat2.id) }
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

  describe "POST create" do
    context "with authenticated user" do
      let(:user) { User.create(email: Faker::Internet.email, password: "password", full_name: Faker::Name.name) }
      let(:cat1) { Category.create(name: "Horror") }
      let(:vid1) { Video.create(title: Faker::Book.name, description: Faker::Lorem.sentence, category_id: cat1.id) }

      before { session[:user_id] = user.id }

      it "redirects to my-queue page" do
        post :create, video_id: vid1.id, user_id: user.id
        expect(response).to redirect_to my_queue_path
      end

      it "adds q_item to user's queue" do
        post :create, video_id: vid1.id, user_id: user.id
        expect(user.q_items.size).to eq(1)
      end

      it "adds q_item to the end of q" do
        position = 1
        10.times do
          vid = Video.create(title: Faker::Book.name, description: Faker::Lorem.sentence, category: cat1)
          QItem.create(user_id: user.id, video_id: vid.id, position: position)
          position += 1
        end

        post :create, video_id: vid1.id, user_id: user.id
        expect(user.q_items.last.video_id).to eq(vid1.id)
      end

      it "creates q_item associated w/signed-in user" do
        post :create, video_id: vid1.id, user_id: user.id
        expect(QItem.first.user.id).to eq(session[:user_id])
      end

      it "does NOT add video to q if it's already there" do
        QItem.create(video_id: vid1.id, user_id: user.id)
        post :create, video_id: vid1.id, user_id: user.id
        expect(QItem.where(video_id: vid1.id).size).to eq(1)
      end
    end

    context "NO authentication" do
      let(:user) { User.create(email: Faker::Internet.email, password: "password", full_name: Faker::Name.name) }
      let(:cat1) { Category.create(name: "Horror") }
      let(:vid1) { Video.create(title: Faker::Book.name, description: Faker::Lorem.sentence, category_id: cat1.id) }

      it "redirects to login_path" do
        post :create, video_id: vid1.id, user_id: user.id
        expect(response).to redirect_to login_path
      end

      it "does NOT create q_item" do
        post :create, video_id: vid1.id, user_id: user.id
        expect(QItem.count).to eq(0)
      end
    end
  end

  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:user) { User.create(email: Faker::Internet.email, password: "password", full_name: Faker::Name.name) }
      let(:cat1) { Category.create(name: "Horror") }
      let(:vid1) { Video.create(title: Faker::Book.name, description: Faker::Lorem.sentence, category_id: cat1.id) }
      let(:q_item) { QItem.create(video: vid1, user: user, position: 1) }
      before { session[:user_id] = user.id }

      it "removes the q_item from db" do
        delete :destroy, id: q_item.id
        expect(QItem.count).to eq(0)
      end

      it "removes q_item associated w/user from db" do
        delete :destroy, id: q_item.id
        expect(user.q_items.size).to eq(0)
      end

      it "does NOT delete a different user's queue item" do
        user2 = User.create(email: Faker::Internet.email, password: "123456", full_name: Faker::Name.name)
        new_user_q_item = QItem.create(video: vid1, user: user2, position: 1)

        delete :destroy, id: new_user_q_item
        expect(user2.q_items.size).to eq(1)
      end

      it "redirects to my_queue_path if q_item doesn't exist" do
        delete :destroy, id: 99
        expect(response).to redirect_to my_queue_path
      end
    end

    context "NO authentication" do
      let(:user) { User.create(email: Faker::Internet.email, password: "password", full_name: Faker::Name.name) }
      let(:cat1) { Category.create(name: "Horror") }
      let(:vid1) { Video.create(title: Faker::Book.name, description: Faker::Lorem.sentence, category_id: cat1.id) }
      let(:q_item) { QItem.create(video: vid1, user: user, position: 1) }

      it "does NOT remove the q_item from the user's q" do
        delete :destroy, id: q_item.id
        expect(user.q_items.size).to eq(1)
      end

      it "redirects to login path" do
        delete :destroy, id: q_item.id
        expect(response).to redirect_to login_path
      end
    end
  end
end
