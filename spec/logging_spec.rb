require "spec_helper"

describe Scrapey::Logging do
  include Scrapey::Logging

  it "provides a logger" do
    expect(logger).to be_kind_of Logger
  end
end
