require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe "#recent_videos" do
    it "returns empty array if none exist" do
      expect(Category.recent_videos).to eq([])
    end

    it "returns maximum 6 recent videos if more than 6" do
      titles = ["one", "22", "three", "FOUR", "5F5I5V5E", "SIX", "seven", "888"]

      titles.each do |title|
        Video.create(title: title, description: "This the #{title} movie")
      end

      expect(Category.recent_videos.size).to be <= 6
    end

    it "returns 6 videos in reverse chronological order, by created_at" do
      titles = ["one", "22", "three", "FOUR", "5F5I5V5E", "SIX", "seven", "888"]
      num = 8

      titles.each do |title|
        Video.create(title: title, description: "This the #{title} movie", created_at: num.days.ago)
        num -= 1
      end

      vids = Category.recent_videos
      ordered = true

      vids.each_with_index do |vid, idx|
        break if idx == vids.size - 1
        ordered = false if vid.created_at < vids[idx + 1].created_at
      end

      expect(ordered).to eq(true)
    end
  end
end

describe "#recent_videos" do
  it "returns max 6 videos in that category, reverse chron order, desc" do
    cat = Category.create(name: "comedy")
    titles = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    ordered = true

    titles.each do |title|
      Video.create(title: title, description: "Nothing", category: cat, created_at: rand(1_000).days.ago)
    end

    vids = cat.recent_videos
    vids.each_with_index do |vid, idx|
      break if idx == vids.size - 1
      ordered = false if vid.created_at < vids[idx + 1].created_at
    end

    expect(ordered).to eq(true)
    expect(vids.size).to eq(6)
  end
end