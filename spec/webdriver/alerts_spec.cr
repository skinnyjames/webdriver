require "../spec_helper"

class Alerts
  include Webdriver::Alerts
end

describe Webdriver::Alerts do
  subject = Alerts.new

  describe "#dismiss_alert, #accept_alert, #alert, #alert=" do
    it "works" do
      subject.responds_to?(:dismiss_alert).should be_true
      subject.responds_to?(:accept_alert).should be_true
      subject.responds_to?(:alert).should be_true
      subject.responds_to?(:alert=).should be_true
    end
  end
end
