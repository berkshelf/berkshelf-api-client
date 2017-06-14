require 'spec_helper'

describe Berkshelf::APIClient::Connection do
  let(:instance) { described_class.new("http://supermarket.getchef.com") }

  describe "#universe" do
    before do
      body_response = %Q{{"ruby":{"1.2.3":{"endpoint_priority":0,"platforms":{},"dependencies":{"build-essential":">= 1.2.2"},"location_type":"supermarket","location_path":"https://supermarket.getchef.com/"},"2.0.0":{"endpoint_priority":0,"platforms":{},"dependencies":{"build-essential":">= 1.2.2"},"location_type":"supermarket","location_path":"https://supermarket.getchef.com/"}},"elixir":{"1.0.0":{"endpoint_priority":0,"platforms":{"CentOS":"= 6.0.0"},"dependencies":{},"location_type":"supermarket","location_path":"https://supermarket.getchef.com/"}}}}

       stub_request(:get, "http://supermarket.getchef.com/universe")
         .to_return(status: 200, body: body_response, headers: { "Content-Type" => "application/json; charset=utf-8" })
    end

    subject { instance.universe }

    it "returns an array of APIClient::RemoteCookbook" do
      expect(subject).to be_a(Array)

      subject.each do |remote|
        expect(remote).to be_a(Berkshelf::APIClient::RemoteCookbook)
      end
    end

    it "contains a item for each dependency" do
      expect(subject.size).to eq(3)
      expect(subject[0].name).to eql("ruby")
      expect(subject[0].version).to eql("1.2.3")
      expect(subject[1].name).to eql("ruby")
      expect(subject[1].version).to eql("2.0.0")
      expect(subject[2].name).to eql("elixir")
      expect(subject[2].version).to eql("1.0.0")
    end

    it "has the dependencies for each" do
      expect(subject[0].dependencies).to include("build-essential" => ">= 1.2.2")
      expect(subject[1].dependencies).to include("build-essential" => ">= 1.2.2")
      expect(subject[2].dependencies).to be_empty
    end

    it "has the platforms for each" do
      expect(subject[0].platforms).to be_empty
      expect(subject[1].platforms).to be_empty
      expect(subject[2].platforms).to include("CentOS" => "= 6.0.0")
    end

    it "has a location_path for each" do
      subject.each do |remote|
        expect(remote.location_path).to_not be_nil
      end
    end

    it "has a location_type for each" do
      subject.each do |remote|
        expect(remote.location_type).to_not be_nil
      end
    end

    #context "when the connection to the service fails" do
    #  before do
    #    expect(instance).to receive(:get).and_raise(Faraday::Error::ConnectionFailed.new(StandardError))
    #  end

    #  it "raises a Berkshelf::APIClient::ServiceUnavailable" do
    #    expect { subject }.to raise_error(Berkshelf::APIClient::ServiceUnavailable)
    #  end
    #end
  end
end
