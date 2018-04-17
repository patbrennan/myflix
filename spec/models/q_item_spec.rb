require "spec_helper"

describe QItem do
  it { should belong_to :user }
  it { should belong_to :video }

end