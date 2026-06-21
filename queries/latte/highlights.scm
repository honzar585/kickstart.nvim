; Document structure
(document) @scope

; Comments
(comment) @comment
(latte_comment) @comment

; Doctype
(doctype) @constant

; Tags
(tag_name) @tag
(start_tag (tag_name) @tag)
(end_tag (tag_name) @tag)
(self_closing_tag (tag_name) @tag)

; Script and style elements
(script_element
  (start_tag (tag_name) @tag)
)

(style_element
  (start_tag (tag_name) @tag)
)

; Attributes
(attribute_name) @attribute
(attribute_value) @string
(quoted_attribute_value (attribute_value) @string)

; Latte-specific attributes
(latte_attribute_name) @attribute.latte
(latte_attribute_value) @string
(quoted_latte_attribute_value (latte_attribute_value) @string)

; Entities
(entity) @character.special

; Text content
(text) @none

; Raw text elements (script, style)
(raw_text) @text

; Latte tags and comments
(latte_tag) @variable.builtin 
; Error handling - fix erroneous_end_tag structure
(erroneous_end_tag) @error
(erroneous_end_tag_name) @error
