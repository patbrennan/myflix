require "spec_helper"

describe Review do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :rating }
  it { should validate_presence_of :description }
  it { should validate_inclusion_of(:rating).in_array([1, 2, 3, 4, 5]) }

  it "doesn't save when rating is < 1 or > 5"


end