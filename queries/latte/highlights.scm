; Comments
(latte_comment) @comment.block

; Tag delimiters
["{" "}"] @punctuation.bracket

; Control flow keywords
(tag_open name: [
  "if"
  "elseif"
  "else"
  "foreach"
  "for"
  "while"
  "ifset"
  "ifcontent"
] @keyword.conditional)

(tag_close name: [
  "if"
  "foreach"
  "for"
  "while"
  "ifset"
  "ifcontent"
] @keyword.conditional)

; Block/template keywords
(tag_open name: [
  "block"
  "define"
  "snippet"
  "capture"
] @keyword.function)

(tag_close name: [
  "block"
  "define"
  "snippet"
  "capture"
] @keyword.function)

; Cache keyword
(tag_open name: "cache" @keyword.storage)
(tag_close name: "cache" @keyword.storage)

; Form keywords
(tag_open name: [
  "form"
  "label"
] @keyword)

(tag_close name: [
  "form"
  "label"
] @keyword)

; Include/import keywords
(tag_single name: [
  "include"
  "import"
  "extends"
  "layout"
  "embed"
] @keyword.import)

; Variable/assignment keywords
(tag_single name: [
  "var"
  "default"
] @keyword.storage)

; Debugging keywords
(tag_single name: [
  "dump"
  "debugbreak"
] @keyword.debug)

; Special syntax keywords
(tag_single name: [
  "l"
  "r"
  "syntax"
  "spaceless"
] @keyword)

; Control keywords
(tag_single name: [
  "breakIf"
  "continueIf"
  "rollback"
  "commit"
  "do"
] @keyword.control)

; Loop special keywords
(tag_single name: [
  "first"
  "last"
  "sep"
  "iterateWhile"
  "case"
] @keyword)

; Meta keywords
(tag_single name: [
  "contentType"
  "status"
  "php"
] @keyword)

; Expression content
(tag_expression) @variable

; Content (HTML/text outside Latte tags)
(text) @none
