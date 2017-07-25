require "spec_helper"

RSpec.describe Canned do
  it "has a version number" do
    expect(Canned::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
