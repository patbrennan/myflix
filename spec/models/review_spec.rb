require "spec_helper"

describe Review do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :rating }
  it { should validate_presence_of :description }
  it { should validate_inclusion_of(:rating).in_array([1, 2, 3, 4, 5]) }

  it "doesn't save when rating is < 1 or > 5" do
    category = Category.new(name: "Comedy")
    user = User.create(email: Faker::Internet.email, password: "123456", full_name: Faker::Name.name)
    video = Video.create(title: "Ghostbusters", description: "Nothing", category: category)
    review1 = Review.create(user: user, video: video, rating: 0, description: "A zero rating")
    review2 = Review.create(user: user, video: video, rating: 6, description: "A 6 rating")

    expect(video.reviews.blank?).to eq(true)
  end
end