require "spec_helper"

RSpec.describe CannedSoap do
  it "has a version number" do
    expect(CannedSoap::VERSION).not_to be nil
  end
end
