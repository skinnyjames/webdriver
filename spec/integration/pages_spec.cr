require "../spec_helper"
require "../fixture/pages/*"

describe Webdriver::PageObject do
  describe "without args" do
    it "selects elements" do
      with_browser("page_object.html") do |browser|
        on(Page::FirstInteractable, browser) do |page|
          # select behavior
          page.select_opt_1_selected?.should eq(true)
          page.select_opt_1_value.should eq("1")
          page.select_m = /option 2/
          page.select_m.should eq("2")
          page.select_opt_1_selected?.should eq(false)

          # radio behavior
          page.grapes_selected?.should eq(false)
          page.apple_selected?.should eq(false)
          page.pick_apple
          page.apple_selected?.should eq(true)

          # checkbox
          page.prechecked_checked?.should eq(true)
          page.toggle_prechecked
          page.prechecked_checked?.should eq(false)

          # buttons and links
          page.trigger_link_alert
          browser.alert.should eq("link alert")
          browser.dismiss_alert

          page.trigger_button_alert
          browser.alert.should eq("button alert")
          browser.dismiss_alert

          # inputs
          page.text_m = "foo"
          page.text_m.should eq("foo")

          page.password_m = "bar"
          page.password_m.should eq("bar")

          page.textarea_m = "foobar"
          page.textarea_m.should eq("foobar")
        end
      end
    end

    it "returns text" do
      with_browser("page_object.html") do |browser|
        on(Page::FirstViewable, browser) do |page|
          page.img_m_element.attr("src").should eq("file://some.png")
          page.div_m.should eq("div_content")
          page.ul_m.should eq("ul_content")
          page.li_m.should eq("li_content")
          page.p_m.should eq("p_content")
          page.header_m.should eq("header_content")
          page.nav_m.should eq("nav_content")
          page.ol_m.should eq("ol_content")
          page.dl_m.should eq("dl_content")
          page.dt_m.should eq("dt_content")
          page.dd_m.should eq("dd_content")
          page.section_m.should eq("section_content")
          page.h1_m.should eq("h1_content")
          page.h2_m.should eq("h2_content")
          page.h3_m.should eq("h3_content")
          page.h4_m.should eq("h4_content")
          page.h5_m.should eq("h5_content")
          page.h6_m.should eq("h6_content")
          page.article_m.should eq("article_content")
          page.blockquote_m.should eq("blockquote_content")
          page.pre_m.should eq("pre_content")
          page.code_m.should eq("code_content")
          page.footer_m.should eq("footer_content")
          page.small_m.should eq("small_content")
          page.span_m.should eq("span_content")
          page.abbr_m.should eq("abbr_content")
          page.figure_m.should eq("figure_content")
          page.caption_m.should eq("caption_content")
          page.table_m.should eq("th_content\ntd_content\ntfoot_content")
          page.thead_m.should eq("th_content")
          page.th_m.should eq("th_content")
          page.tr_m.should eq("th_content")
          page.th_m.should eq("th_content")
          page.tfoot_m.should eq("tfoot_content")
          page.tbody_m.should eq("td_content")
          page.td_m.should eq("td_content")
          page.address_m.should eq("address_content")
          page.form_m.should eq("form_content")
          page.fieldset_m.should eq("fieldset_content")
          page.legend_m.should eq("legend_content")
          page.label_m.should eq("label_content")
          page.iframe_m.should eq("iframe_content")          
        end
      end
    end
  end

  it "selects elements" do
    with_browser("page_object.html") do |browser|
      on(Page::Interactable, browser) do |page|
        # select behavior
        page.select_opt_2_selected?.should eq(false)
        page.select_opt_2_value.should eq("2")
        page.select_m = /option 2/
        page.select_m.should eq("2")
        page.select_opt_2_selected?.should eq(true)

        # radio behavior
        page.grapes_selected?.should eq(false)
        page.apple_selected?.should eq(false)
        page.pick_apple
        page.apple_selected?.should eq(true)

        # checkbox
        page.prechecked_checked?.should eq(true)
        page.toggle_prechecked
        page.prechecked_checked?.should eq(false)

        # buttons and links
        page.trigger_link_alert
        browser.alert.should eq("link alert")
        browser.dismiss_alert

        page.trigger_button_alert
        browser.alert.should eq("button alert")
        browser.dismiss_alert

        # inputs
        page.text_m = "foo"
        page.text_m.should eq("foo")

        page.password_m = "bar"
        page.password_m.should eq("bar")

        page.textarea_m = "foobar"
        page.textarea_m.should eq("foobar")
      end
    end
  end

  it "returns text" do
    with_browser("page_object.html") do |browser|
      on(Page::Viewable, browser) do |page|
        page.img_m_element.attr("src").should eq("file://some.png")
        page.div_m.should eq("div_content")
        page.ul_m.should eq("ul_content")
        page.li_m.should eq("li_content")
        page.p_m.should eq("p_content")
        page.header_m.should eq("header_content")
        page.nav_m.should eq("nav_content")
        page.ol_m.should eq("ol_content")
        page.dl_m.should eq("dl_content")
        page.dt_m.should eq("dt_content")
        page.dd_m.should eq("dd_content")
        page.section_m.should eq("section_content")
        page.h1_m.should eq("h1_content")
        page.h2_m.should eq("h2_content")
        page.h3_m.should eq("h3_content")
        page.h4_m.should eq("h4_content")
        page.h5_m.should eq("h5_content")
        page.h6_m.should eq("h6_content")
        page.article_m.should eq("article_content")
        page.blockquote_m.should eq("blockquote_content")
        page.pre_m.should eq("pre_content")
        page.code_m.should eq("code_content")
        page.footer_m.should eq("footer_content")
        page.small_m.should eq("small_content")
        page.span_m.should eq("span_content")
        page.abbr_m.should eq("abbr_content")
        page.figure_m.should eq("figure_content")
        page.caption_m.should eq("caption_content")
        page.table_m.should eq("th_content\ntd_content\ntfoot_content")
        page.thead_m.should eq("th_content")
        page.th_m.should eq("th_content")
        page.tr_m.should eq("td_content")
        page.th_m.should eq("th_content")
        page.tfoot_m.should eq("tfoot_content")
        page.tbody_m.should eq("td_content")
        page.td_m.should eq("td_content")
        page.address_m.should eq("address_content")
        page.form_m.should eq("form_content")
        page.fieldset_m.should eq("fieldset_content")
        page.legend_m.should eq("legend_content")
        page.label_m.should eq("label_content")
        page.iframe_m.should eq("iframe_content")          
      end
    end
  end
end