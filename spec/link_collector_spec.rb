require "spec_helper"

describe Scrapey::LinkCollector do
  describe "collect_links" do

    subject do
      Scrapey::LinkCollector.new
    end

    let(:base_url){ "http://www.example.com" }

    context "happy path" do

      let(:html) do
        """
        <html><body>
        Find this one <a href='#{base_url}/findme'>blah</a>
        And this one  <a href='#{base_url}/findmetoo'>blah</a>
        Duplicate  <a href='#{base_url}/findmetoo'>blah</a>
        But not this one <a href='http://twitter.com/raykrueger'>blah</a>
        </body></html>
        """
      end

      let(:collected_links){ subject.collect_links(base_url) }

      before do
        stub_request(:get, base_url).
         to_return(status: 200, body: html)
      end

      it "collects followable links" do
        expect(collected_links).to eq ["http://www.example.com/findme", "http://www.example.com/findmetoo"]
      end

      it "does not collect external links" do
        expect(collected_links).to_not include "http://twitter.com/raykrueger"
      end
    end

    context "with errors" do
      
      before do
        stub_request(:get, base_url).
         to_return(status: 500, body: "BOOM")
      end

      it "collects followable links" do
        expect{ subject.collect_links(base_url) }.to raise_error RestClient::InternalServerError
      end

    end

  end
end
