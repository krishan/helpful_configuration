require "spec_helper"
require "helpful_configuration"

describe HelpfulConfiguration do
  let(:config) { HelpfulConfiguration.new({"spam" => "foo"}, "some_file") }

  describe "when a configuration key is explained but missing" do
    before do
      config.explain("eggs", "This is eggs")
    end

    it "should raise an error" do
      expect { config["eggs"] }.to raise_error(HelpfulConfiguration::ConfigurationMissingError)
    end

    it "should mention the explanation" do
      expect { config["eggs"] }.to raise_error(/key.*missing.*This is eggs/)
    end

    it "should mention the file name" do
      expect { config["eggs"] }.to raise_error(/key.*missing.*some_file/)
    end
  end

  it "should complain when a configuration key has not been explained" do
    expect { config["spam"] }.to raise_error(/explanation/)
    expect { config["eggs"] }.to raise_error(/explanation/)
    expect { config.with_default("foo", "spam") }.to raise_error(/explanation/)
    expect { config.with_default("foo", "eggs") }.to raise_error(/explanation/)
    expect { config.configured?("spam") }.to raise_error(/explanation/)
    expect { config.configured?("eggs") }.to raise_error(/explanation/)
  end

  it "should return a configuration key's value" do
    config.explain("spam", "This is spam")
    config["spam"].should == "foo"
  end

  it "should check if a configuration key has been configured" do
    config.explain("spam", "This is spam")
    config.explain("eggs", "This is eggs")
    config.should be_configured("spam")
    config.should_not be_configured("eggs")
  end

  it "should allow defaults for missing configuration keys" do
    config.explain("eggs", "This is eggs")
    config.with_default("bar", "eggs").should == "bar"
  end

  it "should allow setting keys manually" do
    config = HelpfulConfiguration.new
    config.explain("spam", "This is spam")
    config["spam"] = "bar"
    config["spam"].should == "bar"
  end
end
