; Inject HTML into text sections
((text) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined))
