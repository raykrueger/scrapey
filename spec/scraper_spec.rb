require "spec_helper"

describe Scrapey::Scraper do

  let(:scraper){ Scrapey::Scraper.new }

  describe "simple" do


    let(:body){
    """
    <a href='1'/>
    <a href='1'/>
    <a href='2'/>
    <a href='2'/>
    """
    }

    before do
      stub_request(:get, "http://www.example.com/").
        to_return(status: 200, body: body, headers: {"Content-Type" => "text/html"})

      stub_request(:get, "http://www.example.com/1").
        to_return(status: 200, body: body, headers: {"Content-Type" => "text/html"})
      
      stub_request(:get, "http://www.example.com/2").
        to_return(status: 200, body: body, headers: {"Content-Type" => "text/html"})
    end

    it "scrapes like mad" do
      result = scraper.scrape "http://www.example.com"
      expect(result).to eq(
        {"http://www.example.com"=>["http://www.example.com/1", "http://www.example.com/2"],
         "http://www.example.com/1"=>["http://www.example.com/1", "http://www.example.com/2"],
         "http://www.example.com/2"=>["http://www.example.com/1", "http://www.example.com/2"]}
      )
    end
  end

  describe "redirects and such" do

    let(:body){
    """
    <a href='1'/>
    <a href='http://twitter.com/raykrueger'/>
    """
    }

    before do
      stub_request(:get, "http://www.example.com/").
        to_return(status: 200, body: body, headers: {"Content-Type" => "text/html"})

      stub_request(:get, "http://www.example.com/1").
        to_return(status: 302, headers: {"Location" => "http://twitter.com/raykrueger"})
    end

    it "scrapes like mad" do
      result = scraper.scrape "http://www.example.com"
      expect(result).to eq(
        {"http://www.example.com"=>["http://www.example.com/1", "http://twitter.com/raykrueger"]}
      )
    end
  end
end
