require "./spec_helper"

Spectator.describe SeleniumWebdriver do

  subject(browser) { SeleniumWebdriver::Browser.start(:chrome) }

  describe "element behavior" do
    before_each do
      browser.goto "http://localhost:8083/selectors.html"
    end

    after_each do
      browser.quit
    end

    it "should navigate on link click" do
      browser.a.click
      h1 = browser.element(id: "destination")
      expect(h1.text).to eq("Link Destination")
    end
  end
end