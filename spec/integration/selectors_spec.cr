require "../spec_helper"

describe Webdriver do
  describe "Basic selectors" do
    it "selects by attribute" do
      with_browser("selectors.html") do |browser|
        link = browser.link(class: "link-destination")
        link.text.should eq "Link"
        div = browser.div(id: "div1")
        div.text.should eq "Div text"
      end
    end

    it "locates by css" do 
      with_browser("elements/text.html") do |browser|
        browser.nav(css: "header nav").text.should eq("Nav text")
        tr = browser.trs(css: "#table-id tr")[1]
        tr.text.should eq("Tr text")
      end
    end

    it "read element text" do 
      with_browser("elements/text.html") do |browser|
        browser.body.should_not be(nil)
        browser.header.nav.text.should eq("Nav text")
        browser.header.text.should eq("Nav text")
        browser.div.text.should eq("Div text")
        browser.button.text.should eq("Button text")
        browser.li.text.should eq("Li text")
        browser.ol.text.should eq("Ol text")
        browser.ul.text.should eq("Li text\nOl text")
        browser.link.text.should eq("Link text")
        browser.h1.text.should eq("H1 text")
        browser.h2.text.should eq("H2 text")
        browser.h3.text.should eq("H3 text")
        browser.h4.text.should eq("H4 text")
        browser.h5.text.should eq("H5 text")
        browser.h6.text.should eq("H6 text")
        browser.img.attr("src").should eq("img-src")
        browser.article.text.should eq("Article text")
        browser.blockquote.text.should eq("Blockquote text")
        browser.pre.text.should eq("Pre text")
        browser.code.text.should eq("Code text")
        browser.footer.text.should eq("Footer text")
        browser.progress.text.should eq("Progress text")
        browser.small.text.should eq("Small text")
        browser.abbr.text.should eq("Abbr text")
        browser.figure.text.should eq("Figure text")
        browser.caption.text.should eq("Caption text")
        browser.table.attr("id").should eq("table-id")
        browser.th.text.should eq("Th text")
        browser.tr(index: 1).text.should eq("Tr text")
        browser.tr(index: 2).td.text.should eq("Td text")
        browser.address.text.should eq("Address text")
        browser.form.text.should eq("Form text")
        browser.legend.text.should eq("Legend text")
      end
    end
  end
end
