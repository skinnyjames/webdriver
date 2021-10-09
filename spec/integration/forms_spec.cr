require "../spec_helper"

describe Webdriver do
  describe "element behavior" do
    it "should navigate on link click" do
      with_browser("elements/form.html") do |browser|
        text_field = browser.form.text_field(id: /first-name/i)
        text_field.set("Sean")
        text_field.value.should eq("Sean")
        checkbox = browser.checkbox(id: "like-blue")
        checkbox.checked?.should eq(false)
        checkbox.check
        checkbox.checked?.should eq(true)
        browser.radio(id: "radio-1").select
        radio_2 = browser.radio(id: "radio-2")
        radio_2.selected?.should eq(false)
        radio_2.select
        radio_2.selected?.should eq(true)
        select_list = browser.select_list
        select_list.select(/TWO/i)
        select_list.value.should eq("two")
      end
    end
  end
end