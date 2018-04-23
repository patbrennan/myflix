require "spec_helper"

describe QItem do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :video_id }
  it { should validate_numericality_of :position }
end