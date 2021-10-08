require "../spec_helper"

describe Webdriver do
  describe "element behavior" do
    it "should navigate on link click" do
      with_browser("elements/form.html") do |browser|
        text_field = browser.form.text_field(id: /first-name/i)
        text_field.set("Sean")
        text_field.value.should eq("Sean")
      end
    end
  end
end