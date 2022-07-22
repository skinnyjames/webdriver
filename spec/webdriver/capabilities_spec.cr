require "../spec_helper"

describe Webdriver::Capabilities do
  describe Webdriver::Capabilities::Chrome do
    describe "capabilities" do
      subject = Webdriver::Capabilities::Chrome.new

      it "has correct capabilities" do
        json = Hash(String, Hash(String, Hash(String, String | Bool | Hash(String, String)))).from_json(subject.to_json)
        json.should eq({
          "capabilities" => {
            "alwaysMatch" => {
              "browserName" => "chrome",
              "acceptInsecureCerts" => true,
              "goog:chromeOptions" => {} of String => String
            }
          }
        })
      end
    end
  end

  describe Webdriver::Capabilities::Firefox do
    describe "capabilities" do
      subject = Webdriver::Capabilities::Firefox.new

      it "has correct capabilities" do
        json = Hash(String, Hash(String, Hash(String, String | Bool | Hash(String, String)))).from_json(subject.to_json)
        json.should eq({
          "capabilities" => {
            "alwaysMatch" => {
              "browserName" => "firefox",
              "acceptInsecureCerts" => true,
              "moz:firefoxOptions" => {} of String => String
            }
          }
        })
      end
    end
  end
end
