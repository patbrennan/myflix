require "spec_helper"

describe QItemsController do

  describe "GET index" do
    context "with authenticated user" do
      let(:user) { create_user }
      let(:cat1) { Category.create(name: "Horror") }
      let(:cat2) { Category.create(name: "Comedy") }
      let(:vid1) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }
      let(:vid2) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat2) }
      let(:q1) { create_q_item(user, vid1, 1) }
      let(:q2) { create_q_item(user, vid2, 2) }

      before { set_current_user }

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
      it_behaves_like "require_user" do
        let(:action) { get :index }
      end
    end
  end

  describe "POST create" do
    context "with authenticated user" do
      let(:user) { create_user }
      let(:cat1) { create_category }
      let(:vid1) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }

      before { set_current_user }

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
          vid = create_video(Faker::Book.name, Faker::Lorem.sentence, cat1)
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
      let(:user) { create_user }
      let(:cat1) { Category.create(name: "Horror") }
      let(:vid1) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }

      it_behaves_like "require_user" do
        let(:action) { post :create, video_id: vid1.id, user_id: user.id }
      end

      it "does NOT create q_item" do
        post :create, video_id: vid1.id, user_id: user.id
        expect(QItem.count).to eq(0)
      end
    end
  end

  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:user) { create_user }
      let(:cat1) { Category.create(name: "Horror") }
      let(:vid1) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }
      let(:q_item) { QItem.create(video: vid1, user: user, position: 1) }
      before { set_current_user }

      it "removes the q_item from db" do
        delete :destroy, id: q_item.id
        expect(QItem.count).to eq(0)
      end

      it "removes q_item associated w/user from db" do
        delete :destroy, id: q_item.id
        expect(user.q_items.size).to eq(0)
      end

      it "does NOT delete a different user's queue item" do
        user2 = create_user
        new_user_q_item = QItem.create(video: vid1, user: user2, position: 1)

        delete :destroy, id: new_user_q_item.id
        expect(user2.q_items.size).to eq(1)
      end

      it "redirects to my_queue_path if q_item doesn't exist" do
        delete :destroy, id: 99
        expect(response).to redirect_to my_queue_path
      end

      it "normalizes remaining q_items positions" do
        vid2 = create_video(Faker::Book.name, Faker::Lorem.sentence, cat1)
        vid3 = create_video(Faker::Book.name, Faker::Lorem.sentence, cat1)
        q_item1 = QItem.create(video: vid1, user: user, position: 1)
        q_item2 = QItem.create(video: vid2, user: user, position: 2)
        q_item3 = QItem.create(video: vid3, user: user, position: 3)

        delete :destroy, id: q_item2.id
        expect(user.q_items.last.position).to eq(2)
      end
    end

    context "NO authentication" do
      let(:user) { create_user }
      let(:cat1) { Category.create(name: "Horror") }
      let(:vid1) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }
      let(:q_item) { QItem.create(video: vid1, user: user, position: 1) }

      it "does NOT remove the q_item from the user's q" do
        delete :destroy, id: q_item.id
        expect(user.q_items.size).to eq(1)
      end

      it_behaves_like "require_user" do
        let(:action) { delete :destroy, id: q_item.id }
      end
    end
  end

  describe "POST update_q" do
    context "with valid inputs" do
      let(:user) { create_user }
      let(:cat1) { Category.create(name: "Horror") }
      let(:vid1) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }
      let(:vid2) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }
      before { set_current_user }

      it "redirects to my_q page" do
        q_item1 = QItem.create(video: vid1, user: user, position: 1)
        q_item2 = QItem.create(video: vid2, user: user, position: 2)

        post :update_q, q_items: [
          {id: q_item1.id, position: 2},
          {id: q_item2.id, position: 1}
        ]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the q_items" do
        q_item1 = QItem.create(video: vid1, user: user, position: 1)
        q_item2 = QItem.create(video: vid2, user: user, position: 2)

        post :update_q, q_items: [
          {id: q_item1.id, position: 2},
          {id: q_item2.id, position: 1}
        ]
        expect(user.q_items).to eq([q_item2, q_item1])
      end

      it "normalizes the position numbers" do
        q_item1 = QItem.create(video: vid1, user: user, position: 1)
        q_item2 = QItem.create(video: vid2, user: user, position: 2)

        post :update_q, q_items: [
          {id: q_item1.id, position: 3},
          {id: q_item2.id, position: 2}
        ]
        expect(user.q_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with INVALID inputs" do
      let(:user) { create_user }
      let(:cat1) { Category.create(name: "Horror") }
      let(:vid1) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }
      let(:vid2) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }
      before { set_current_user }

      it "redirects to my_queue page" do
        q_item1 = QItem.create(video: vid1, user: user, position: 1)
        q_item2 = QItem.create(video: vid2, user: user, position: 2)

        post :update_q, q_items: [
          {id: q_item1.id, position: 3.7},
          {id: q_item2.id, position: 2}
        ]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do
        q_item1 = QItem.create(video: vid1, user: user, position: 1)
        q_item2 = QItem.create(video: vid2, user: user, position: 2)

        post :update_q, q_items: [
          {id: q_item1.id, position: 3.7},
          {id: q_item2.id, position: 2}
        ]
        expect(flash[:error]).to be_present
      end

      it "does not change q_items in db" do
        q_item1 = QItem.create(video: vid1, user: user, position: 1)
        q_item2 = QItem.create(video: vid2, user: user, position: 2)

        post :update_q, q_items: [
          {id: q_item1.id, position: 3},
          {id: q_item2.id, position: 2.1}
        ]
        expect(q_item1.reload.position).to eq(1) # requires reload to properly eval
      end
    end

    context "with unauthenticated users" do
      let(:user) { create_user }
      let(:cat1) { Category.create(name: "Horror") }
      let(:vid1) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }
      let(:vid2) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }

      it "redirects to login path" do
        q_item1 = QItem.create(video: vid1, user: user, position: 1)
        q_item2 = QItem.create(video: vid2, user: user, position: 2)

        post :update_q, q_items: [
          {id: q_item1.id, position: 2},
          {id: q_item2.id, position: 1}
        ]
      end
    end

    context "with q items NOT belonging to current user" do
      let(:user) { create_user }
      let(:user2) { create_user }
      let(:cat1) { Category.create(name: "Horror") }
      let(:vid1) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }
      let(:vid2) { create_video(Faker::Book.name, Faker::Lorem.sentence, cat1) }
      before { set_current_user }

      it "does not change the q_items" do
        q_item1 = QItem.create(video: vid1, user: user2, position: 1)
        q_item2 = QItem.create(video: vid2, user: user, position: 2)

        post :update_q, q_items: [
          {id: q_item1.id, position: 2},
          {id: q_item2.id, position: 1}
        ]
        expect(q_item1.reload.position).to eq(1)
      end
    end
  end

end
