module Webdriver::PageObject
  getter :browser

  def initialize(@browser : Webdriver::Browser); end

  macro settable(*types)
    {% for type in types %}
      macro {{ type }}(method, **attrs)
        \{% if attrs.empty? %}
          def \{{ method.id }}
            browser.{{type.id }}.value
          end

          def \{{ method.id }}=(text : String)
            browser.{{ type.id }}.set(text)
          end

          def \{{ method.id }}_element
            browser.{{ type.id }}
          end
        \{% else %}
          def \{{ method.id }}
            browser.{{type.id }}(**\{{ attrs }}).value
          end

          def \{{ method.id }}=(text : String)
            browser.{{ type.id }}(**\{{ attrs }}).set(text)
          end

          def \{{ method.id }}_element
            browser.{{ type.id }}(**\{{ attrs }})
          end
        \{% end %}
      end

      macro {{ type }}s(method, **attrs)
        \{% if attrs.empty? %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s(**\{{ attrs }})
          end
        \{% else %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s
          end
        \{% end %}          
      end
    {% end %}
  end

  macro clickable(*types)
    {% for type in types %}
      macro {{ type }}(method, **attrs)
        \{% if attrs.empty? %}
          def \{{ method.id }}
            browser.{{ type.id }}.click
          end

          def \{{ method.id }}_element
            browser.{{ type.id }}
          end
        \{% else %}
          def \{{ method.id }}
            browser.{{ type.id }}(**\{{ attrs }}).click
          end

          def \{{ method.id }}_element
            browser.{{ type.id }}(**\{{ attrs }})
          end
        \{% end %}
      end

      macro {{ type }}s(method, **attrs)
        \{% if attrs.empty? %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s(**\{{ attrs }})
          end
        \{% else %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s
          end
        \{% end %}          
      end
    {% end %}
  end

  macro viewable(*types)
    {% for type in types %}
      macro {{ type }}s(method, **attrs)
        \{% if attrs.empty? %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s(**\{{ attrs }})
          end
        \{% else %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s
          end
        \{% end %}          
      end

      macro {{ type }}(method, **attrs)
        \{% unless attrs.empty? %}
          def \{{ method.id }}
            browser.{{ type.id }}(**\{{ attrs }}).text
          end

          def \{{ method.id }}_element
            browser.{{ type.id }}(**\{{ attrs }})
          end
        \{% else %}
          def \{{ method.id }}
            browser.{{ type.id }}.text
          end

          def \{{ method.id }}_element
            browser.{{ type.id }}
          end
        \{% end %}
      end
    {% end %}
  end

  macro selectable(*types)
    {% for type in types %}
      macro {{ type }}s(method, **attrs)
        \{% if attrs.empty? %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s(**\{{ attrs }})
          end
        \{% else %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s
          end
        \{% end %}          
      end

      macro {{ type }}(method, **attrs)
        \{% unless attrs.empty? %}
          def \{{ method.id }}
            browser.{{ type.id }}(**\{{ attrs }}).value
          end

          def \{{ method.id }}_element
            browser.{{ type.id }}(**\{{ attrs }})
          end

          def \{{ method.id }}=(arr : String | Regex | Array(String | Regex))
            if arr.is_a?(Array(String | Regex))
              browser.{{ type.id }}(**\{{ attrs }}).select_many(arr)
            else
              browser.{{ type.id }}(**\{{ attrs }}).select(arr)
            end
          end
        \{% else %}
          def \{{ method.id }}
            browser.{{ type.id }}.value
          end

          def \{{ method.id }}_element
            browser.{{ type.id }}
          end

          def \{{ method.id }}=(arr : String | Regex | Array(String | Regex))
            if arr.is_a?(Array(String | Regex))
              browser.{{ type.id }}.select_many(arr)
            else
              browser.{{ type.id }}.select(arr)
            end
          end
        \{% end %}
      end
    {% end %}
  end

  macro radioable(*types)
    {% for type in types %}
      macro {{ type }}s(method, **attrs)
        \{% if attrs.empty? %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s(**\{{ attrs }})
          end
        \{% else %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s
          end
        \{% end %}          
      end

      macro {{ type }}(method, **attrs)
        \{% unless attrs.empty? %}
          def pick_\{{ method.id }}
            browser.{{ type.id }}(**\{{ attrs }}).select
          end

          def \{{ method.id }}_element
            browser.{{ type.id }}(**\{{ attrs }})
          end

          def \{{ method.id }}_selected?
            browser.{{ type.id }}(**\{{ attrs }}).selected?
          end
        \{% else %}
          def pick_\{{ method.id }}
            browser.{{ type.id }}.select
          end

          def \{{ method.id }}_element
            browser.{{ type.id }}
          end

          def \{{ method.id }}_selected?
            browser.{{ type.id }}.selected?
          end
        \{% end %}
      end
    {% end %}
  end

  macro checkable(*types)
    {% for type in types %}
      macro {{ type }}s(method, **attrs)
       \{% if attrs.empty? %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s(**\{{ attrs }})
          end
        \{% else %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s
          end
        \{% end %}          
      end

      macro {{ type }}(method, **attrs)
        \{% unless attrs.empty? %}
          def \{{ method.id }}_element
            browser.{{ type.id }}(**\{{ attrs }})
          end

          def \{{ method.id }}_checked?
            browser.{{ type.id }}(**\{{ attrs }}).checked?
          end

          def toggle_\{{ method.id }}
            browser.{{ type.id }}(**\{{ attrs }}).check
          end
        \{% else %}
          def \{{ method.id }}_element
            browser.{{ type.id }}
          end

          def \{{ method.id }}_checked?
            browser.{{ type.id }}.checked?
          end

          def toggle_\{{ method.id }}
            browser.{{ type.id }}.check
          end
        \{% end %}
      end
    {% end %}
  end

  macro choosable(*types)
    {% for type in types %}
      macro {{ type }}s(method, **attrs)
        \{% if attrs.empty? %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s(**\{{ attrs }})
          end
        \{% else %}
          def \{{ method.id }}_elements
            browser.{{ type.id }}s
          end
        \{% end %}          
      end


      macro {{ type }}(method, **attrs)
        \{% unless attrs.empty? %}
          def \{{ method.id }}_element
            browser.{{ type.id }}(**\{{ attrs }})
          end

          def \{{ method.id }}_value
            browser.{{ type.id }}(**\{{ attrs }}).value
          end

          def \{{ method.id }}_selected? : Bool
            browser.{{ type.id }}(**\{{ attrs }}).selected?
          end

          def \{{ method.id }}
            browser.{{ type.id }}(**\{{ attrs }}).select
          end
        \{% else %}
          def \{{ method.id }}_element
            browser.{{ type.id }}
          end

          def \{{ method.id }}_value
            browser.{{ type.id }}.value
          end

          def \{{ method.id }}_selected? : Bool
            browser.{{ type.id }}.selected?
          end

          def \{{ method.id }}
            browser.{{ type.id }}.select
          end
        \{% end %}
      end
    {% end %}
  end

  viewable(
    div,
    ul,
    li,
    p,
    body,
    header,
    nav,
    ol,
    dl,
    dt,
    dd,
    section,
    h1,
    h2,
    h3,
    h4,
    h5,
    h6,
    img,
    article,
    blockquote,
    pre,
    code,
    footer,
    small,
    span,
    abbr,
    figure,
    caption,
    table,
    tr,
    th,
    tfoot,
    tbody,
    thead,
    td,
    address,
    form,
    fieldset,
    legend,
    label,
    iframe
  )

  clickable(
    button,
    link
  )

  settable(
    text_field,
    password_field,
    textarea,
    input,
  )

  selectable(select_list)

  choosable(option)
  
  checkable(checkbox)
  
  radioable(radio)
end
