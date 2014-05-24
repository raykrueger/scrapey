require "spec_helper"

describe Scrapey::Logging do
  include Scrapey::Logging

  it "provides a logger" do
    expect(logger).to be_true
  end
end
