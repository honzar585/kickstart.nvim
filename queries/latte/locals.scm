; Local variable definitions for tags
(element
  (start_tag
    (tag_name) @definition.tag
  )
  (end_tag
    (tag_name) @definition.tag
  )
) @scope

; Local variables for script/style elements - reference via the element structure
(script_element
  (start_tag
    (tag_name) @definition.tag
  )
  (end_tag
    (tag_name) @definition.tag
  )
) @scope

(style_element
  (start_tag
    (tag_name) @definition.tag
  )
  (end_tag
    (tag_name) @definition.tag
  )
) @scope

; References to tags
(tag_name) @reference.tag
