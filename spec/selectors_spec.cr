require "./spec_helper"

Spectator.describe SeleniumWebdriver do

  subject(browser) { SeleniumWebdriver::Browser.start(:chrome) }

  describe "Basic selectors" do
    before_each do
       browser.goto "http://localhost:8083/selectors.html"
    end

    after_each do 
      browser.quit
    end

    it "selects by class" do
      link = browser.a(class: "link-destination")
      expect(link.text).to eq("Link")
    end

    it "selects by id" do 
      div = browser.div(id: "div1")
      expect(div.text).to eq("Div text")
    end
  end
end
