require 'spec_helper' # <-- rspec will load rails ENV

describe Video do
  it { should belong_to(:category) } # Tests the declaration exists, not the function of
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#search_by_title" do
    it "returns empty array if no matching video title" do
      vid1 = Video.create(title: "Ghostbusters", description: "Some description", created_at: 1.day.ago)
      vid2 = Video.create(title: "Gone with the Wind", description: "Annoying Musical")
      expect(Video.search_by_title("Irrelevant")).to eq([])
    end
    it "returns single Video object in array if video title found" do
      vid1 = Video.create(title: "Ghostbusters", description: "Some description", created_at: 1.day.ago)
      vid2 = Video.create(title: "Gone with the Wind", description: "Annoying Musical")
      expect(Video.search_by_title("Ghost")).to eq([vid1])
    end
    it "returns array of matches ordered by created_at if multiple matches" do
      vid1 = Video.create(title: "Ghostbusters", description: "Some description", created_at: 1.day.ago)
      vid2 = Video.create(title: "Gone with the Wind", description: "Annoying Musical")
      expect(Video.search_by_title("G")).to eq([vid2, vid1])
    end
    it "returns empty array if empty string is provided" do
      vid1 = Video.create(title: "Ghostbusters", description: "Some description", created_at: 1.day.ago)
      vid2 = Video.create(title: "Gone with the Wind", description: "Annoying Musical")
      expect(Video.search_by_title("")).to eq([])
    end
  end

  describe "#avg_rating" do
    context "one video" do
      let(:video) { Video.create(title: "Ghostbusters", description: "Some description", created_at: 1.day.ago) }

      it "returns zero if no reviews found" do
        expect(video.avg_rating).to eq(0)
      end

      it "returns the value of the rating if only 1 review" do
        review = Review.create(rating: 4, description: "Just a review", video: video)
        expect(video.avg_rating).to eq(4.0)
      end

      it "returns avg rating with 1 decimal place when multiple reviews" do
        review = Review.create(rating: 4, description: "Just a review", video: video)
        review = Review.create(rating: 5, description: "Review me", video: video)
        expect(video.avg_rating).to eq(4.5)
      end
    end
  end
end
