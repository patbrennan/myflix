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
end
