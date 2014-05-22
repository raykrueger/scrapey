require 'spec_helper'

describe Scrapey::LinkEvaluator do
    
  subject{ Scrapey::LinkEvaluator.new("http://www.example.com") }

  describe "initialization" do

    it "has a base_url" do
      expect(subject.base_url).to eq "http://www.example.com"
    end

    it "has a uri" do
      expect(subject.uri.to_s).to eq "http://www.example.com"
    end
  end

  describe "resolve" do
    it "resolves fully qualified urls as is" do
      expect(subject.resolve("http://twitter.com/raykrueger")).to eq "http://twitter.com/raykrueger"
    end

    it "resolves scheme relative urls" do
      expect(subject.resolve("//twitter.com/raykrueger")).to eq "http://twitter.com/raykrueger"
    end

    it "refuses to resolve mailto links" do
      expect(subject.resolve("mailto:nope@example.com")).to be_nil
    end

    it "resolves relative urls" do
      expect(subject.resolve("boosh")).to eq "http://www.example.com/boosh"
    end

    it "resolves relative literal paths" do
      expect(subject.resolve("/boosh")).to eq "http://www.example.com/boosh"
    end
  end

  describe "follow?" do
    it "follows relative urls" do
      expect(subject.follow? "boosh").to be_true
    end

    it "follows fully qualified urls for the same domain" do
      expect(subject.follow? "http://www.example.com/boosh").to be_true
    end

    it "does not follow urls for a different domain" do
      expect(subject.follow? "http://twitter.com/raykrueger").to be_false 
    end

    it "does not follow mailto links" do
      expect(subject.follow? "mailto:nope@example.com").to be_false
    end
  end
end
