; Inject PHP highlighting into Latte tags and attributes
(
  (latte_tag) @injection.content
  (#set! injection.language "php")
)

(
  (latte_attribute_value) @injection.content
  (#set! injection.language "php")
)

(
  (quoted_latte_attribute_value (latte_attribute_value) @injection.content)
  (#set! injection.language "php")
)

; Inject JavaScript into script tags
(
  (script_element
    (start_tag
      (tag_name) @_tag
      (#eq? @_tag "script")
    )
    (raw_text) @injection.content
  )
  (#set! injection.language "javascript")
)

; JavaScript with type attribute
(
  (script_element
    (start_tag
      (tag_name) @_tag
      (#eq? @_tag "script")
      (attribute
        (html_attribute
          (attribute_name) @_attr
          (attribute_value) @_type
          (#eq? @_attr "type")
          (#match? @_type "^(text|application)/(javascript|js)$")
        )
      )
    )
    (raw_text) @injection.content
  )
  (#set! injection.language "javascript")
)

(
  (script_element
    (start_tag
      (tag_name) @_tag
      (#eq? @_tag "script")
      (attribute
        (html_attribute
          (attribute_name) @_attr
          (attribute_value) @_type
          (#eq? @_attr "type")
          (#match? @_type "module")
        )
      )
    )
    (raw_text) @injection.content
  )
  (#set! injection.language "javascript")
)

; Inject CSS into style tags
(
  (style_element
    (start_tag
      (tag_name) @_tag
      (#eq? @_tag "style")
    )
    (raw_text) @injection.content
  )
  (#set! injection.language "css")
)

(
  (style_element
    (start_tag
      (tag_name) @_tag
      (#eq? @_tag "style")
      (attribute
        (html_attribute
          (attribute_name) @_attr
          (attribute_value) @_type
          (#eq? @_attr "type")
          (#match? @_type "text/(css|scss|sass|less)")
        )
      )
    )
    (raw_text) @injection.content
  )
  (#set! injection.language "css")
)
