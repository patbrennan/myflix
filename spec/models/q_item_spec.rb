require "spec_helper"

describe QItem do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :video_id }
  it { should validate_numericality_of :position }

  describe "#rating" do
    it "returns rating from review when review is present" do
      user = User.create(email: "me@me.com", password: "123456", full_name: "Pat B")
      video = Video.create(title: Faker::Book.title, description: Faker::Lorem.paragraph, category: Category.create(name: "Horror"))
      review = Review.create(user_id: user.id, video_id: video.id, rating: 5, description: "My review description")
      q_item = QItem.create(video_id: video.id, user_id: user.id, position: 1)

      expect(q_item.rating).to eq(5)
    end

    it "returns nil when review not present" do
      user = User.create(email: "me@me.com", password: "123456", full_name: "Pat B")
      video2 = Video.create(title: "Video #2", description: Faker::Lorem.paragraph)
      q_item2 = QItem.create(video_id: video2.id, user_id: user.id, position: 2)

      expect(q_item2.rating).to eq(nil)
    end
  end

  describe "#rating=" do
    context "when review present" do
      let(:user) { User.create(email: "me@me.com", password: "123456", full_name: "Pat B") }
      let(:video) { Video.create(title: Faker::Book.title, description: Faker::Lorem.paragraph, category: Category.create(name: "Horror")) }
      let(:review) { Review.create(user_id: user.id, video_id: video.id, rating: 5, description: "My review description") }
      let(:q_item) { QItem.create(video_id: video.id, user_id: user.id, position: 1) }

      it "changes rating of review if review present" do
        q_item.rating = 3
        expect(Review.first.rating).to eq(3)
      end

      it "clears the rating of review if review is present" do
        q_item.rating = nil
        expect(Review.first.rating).to be_nil
      end
    end

    it "creates a review w/the rating if review not present" do
      user = User.create(email: "me@me.com", password: "123456", full_name: "Pat B")
      video = Video.create(title: Faker::Book.title, description: Faker::Lorem.paragraph, category: Category.create(name: "Horror"))
      q_item = QItem.create(video_id: video.id, user_id: user.id, position: 1)

      q_item.rating = 3
      expect(Review.first.rating).to eq(3)
    end
  end
end