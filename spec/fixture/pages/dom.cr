module Page
  class Interactable
    include Webdriver::PageObject

    select_list(:select_m, id: "select-id")
    option(:select_opt_2, id: "option-2")
    radio(:apple, value: "apple")
    radio(:grapes, value: "grapes")
    checkbox(:prechecked, name: "prechecked")

    link(:trigger_link_alert, id: "link")
    button(:trigger_button_alert, id: "button")

    text_field(:text_m, id: "text-id")
    password_field(:password_m, id: "password-id")
    textarea(:textarea_m, id: "textarea-id")
  end

  class Viewable
    include Webdriver::PageObject

    div(:div_m, id: "div-id")
    ul(:ul_m, id: "ul-id")
    li(:li_m, id: "li-id")
    p(:p_m, id: "p-id")
    header(:header_m, id: "header-id")
    nav(:nav_m, id: "nav-id")
    ol(:ol_m, id: "ol-id")
    dl(:dl_m, id: "dl-id")
    dt(:dt_m, id: "dt-id")
    dd(:dd_m, id: "dd-id")
    section(:section_m, id: "section-id")
    h1(:h1_m, id: "h1-id")
    h2(:h2_m, id: "h2-id")
    h3(:h3_m, id: "h3-id")
    h4(:h4_m, id: "h4-id")
    h5(:h5_m, id: "h5-id")
    h6(:h6_m, id: "h6-id")
    img(:img_m, id: "img-id")
    article(:article_m, id: "article-id")
    blockquote(:blockquote_m, id: "blockquote-id")
    pre(:pre_m, id: "pre-id")
    code(:code_m, id: "code-id")
    footer(:footer_m, id: "footer-id")
    small(:small_m, id: "small-id")
    span(:span_m, id: "span-id")
    abbr(:abbr_m, id: "abbr-id")
    figure(:figure_m, id: "figure-id")
    caption(:caption_m, id: "caption-id")
    table(:table_m, id: "table-id")
    tr(:tr_m, id: "tr-id")
    th(:th_m, id: "th-id")
    tfoot(:tfoot_m, id: "tfoot-id")
    thead(:thead_m, id: "thead-id")
    tbody(:tbody_m, id: "tbody-id")
    td(:td_m, id: "td-id")
    address(:address_m, id: "address-id")
    form(:form_m, id: "form-id")
    fieldset(:fieldset_m, id: "fieldset-id")
    legend(:legend_m, id: "legend-id")
    label(:label_m, id: "label-id")
    iframe(:iframe_m, id: "iframe-id")
  end

  class FirstInteractable
    include Webdriver::PageObject

    select_list(:select_m)
    option(:select_opt_1)
    radio(:apple)
    radio(:grapes)
    checkbox(:prechecked)

    link(:trigger_link_alert)
    button(:trigger_button_alert)

    text_field(:text_m)
    password_field(:password_m)
    textarea(:textarea_m)
  end

  class FirstViewable
    include Webdriver::PageObject

    div(:div_m)
    ul(:ul_m)
    li(:li_m)
    p(:p_m)
    header(:header_m)
    nav(:nav_m)
    ol(:ol_m)
    dl(:dl_m)
    dt(:dt_m)
    dd(:dd_m)
    section(:section_m)
    h1(:h1_m)
    h2(:h2_m)
    h3(:h3_m)
    h4(:h4_m)
    h5(:h5_m)
    h6(:h6_m)
    img(:img_m)
    article(:article_m)
    blockquote(:blockquote_m)
    pre(:pre_m)
    code(:code_m)
    footer(:footer_m)
    small(:small_m)
    span(:span_m)
    abbr(:abbr_m)
    figure(:figure_m)
    caption(:caption_m)
    table(:table_m)
    tr(:tr_m)
    th(:th_m)
    tfoot(:tfoot_m)
    thead(:thead_m)
    tbody(:tbody_m)
    td(:td_m)
    address(:address_m)
    form(:form_m)
    fieldset(:fieldset_m)
    legend(:legend_m)
    label(:label_m)
    iframe(:iframe_m)
  end
end