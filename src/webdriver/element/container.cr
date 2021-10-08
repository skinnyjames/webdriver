module Webdriver
  module Dom
    module Container

      macro define_element_method(method_name, class_name, **extra_location)
        def {{ method_name }}(**locator)
          {% if !extra_location.empty? %}
            locator = locator.merge({{ extra_location }}) 
          {% end %}
          {{ class_name }}.new(self, server, **locator)
        end

        def {{ method_name }}s(**locator)
          {% if !extra_location.empty? %}
            locator = locator.merge({{ extra_location }})
          {% end %}
          {{ class_name }}s.new(self, server, **locator)
        end
      end

      define_element_method element, Dom::Element
      define_element_method body, Dom::Body
      define_element_method header, Dom::Header
      define_element_method nav, Dom::Nav
      define_element_method ul, Dom::Ul
      define_element_method ol, Dom::Ol
      define_element_method li, Dom::Li
      define_element_method section, Dom::Section
      define_element_method p, Dom::P
      define_element_method link, Dom::Link
      define_element_method div, Dom::Div

      define_element_method h1, Dom::H1
      define_element_method h2, Dom::H2
      define_element_method h3, Dom::H3
      define_element_method h4, Dom::H4
      define_element_method h5, Dom::H5
      define_element_method h6, Dom::H6

      define_element_method img, Dom::Image
      define_element_method article, Dom::Article
      define_element_method blockquote, Dom::Blockquote
      define_element_method pre, Dom::Pre
      define_element_method code, Dom::Code
      define_element_method footer, Dom::Footer
      define_element_method progress, Dom::Progress
      define_element_method small, Dom::SmallTag
      define_element_method span, Dom::Span
      define_element_method abbr, Dom::Abbr
      define_element_method figure, Dom::Figure
      define_element_method caption, Dom::FigureCaption
      define_element_method table, Dom::Table
      define_element_method thead, Dom::TableHeader
      define_element_method tr, Dom::TableRow
      define_element_method th, Dom::TableHead
      define_element_method tfoot, Dom::TableFooter
      define_element_method td, Dom::TableDefinition
      define_element_method address, Dom::AddressField

      define_element_method dl, Dom::Dl
      define_element_method dt, Dom::Dt
      define_element_method dd, Dom::Dd

      define_element_method form, Dom::Form
      define_element_method fieldset, Dom::Fieldset
      define_element_method legend, Dom::Legend
      define_element_method label, Dom::Label
      define_element_method select_list, Dom::SelectList
      define_element_method option, Dom::SelectOption
      define_element_method radio, Dom::Radio, type: "radio"
      define_element_method input, Dom::Input
      define_element_method text_field, Dom::TextField, type: "text"
      define_element_method password_field, Dom::PasswordField, type: "password"
      define_element_method button, Dom::Button
    end
  end
end