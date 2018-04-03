require 'spec_helper' # <-- rspec will load rails ENV

describe Video do
  it { should belong_to(:category) } # Tests the declaration exists, not the function of
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end
