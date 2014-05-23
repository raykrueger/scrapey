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
         to_return(status: 200, body: html, headers: {"Content-Type" => "text/html"})
      end

      it "collects followable links" do
        expect(collected_links).to eq ["http://www.example.com/findme", "http://www.example.com/findmetoo", "http://twitter.com/raykrueger"]
      end
    end

    context "with errors" do

      context "non-success response" do      
        before do
          stub_request(:get, base_url).
            to_return(status: 500, body: "BOOM")
        end

        it "raises errors" do
          expect{ subject.collect_links(base_url) }.to raise_error Net::HTTPFatalError
        end
      end

      context "too many redirects" do
        before do
          stub_request(:get, base_url).
            to_return(status: 302, headers: {"Location" => base_url})
        end

        it "raises errors" do
          expect{ subject.collect_links(base_url) }.to raise_error Scrapey::LinkCollector::TooManyRedirects
        end
      end

      context "incorrect content type" do
        before do
          stub_request(:get, base_url).
            to_return(status: 200, headers: {"Content-Type" => "image/png"})
        end


        it "raises errors" do
          expect{ subject.collect_links(base_url) }.to raise_error Scrapey::LinkCollector::InvalidContentType
        end
      end

      context "link_evaluator refuses to follow redirect" do
        before do
          stub_request(:get, base_url).
            to_return(status: 302, headers: {"Location" => "http://twitter.com/raykrueger"})
        end


        it "raises errors" do
          expect{ subject.collect_links(base_url) }.to raise_error Scrapey::LinkCollector::ExternalRedirect
        end
      end

    end

  end
end
