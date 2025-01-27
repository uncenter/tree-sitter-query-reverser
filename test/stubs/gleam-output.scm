; From https://github.com/helix-editor/helix/blob/master/runtime/queries/gleam/highlights.scm.

; Punctuation
[
  "."
  ","
  ;; Controversial -- maybe some are operators?
  ":"
  "#"
  "="
  "->"
  ".."
  "-"
  "<-"
] @punctuation.delimiter
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "<<"
  ">>"
] @punctuation.bracket

; Operators
(integer_negation "-" @operator)
(boolean_negation "!" @operator)
(binary_expression
  operator: _ @operator)

; Keywords
[
  (visibility_modifier) ; "pub"
  (opacity_modifier) ; "opaque"
  "as"
  "assert"
  "case"
  "const"
  ; DEPRECATED: 'external' was removed in v0.30.
  "external"
  "fn"
  "if"
  "import"
  "let"
  "panic"
  "todo"
  "type"
  "use"
] @keyword

; Variables
(discard) @comment.unused
(identifier) @variable

; Reserved identifiers
((identifier) @error
 (#any-of? @error "auto" "delegate" "derive" "else" "implement" "macro" "test" "echo"))

; Literals
(float) @constant.numeric.float
(integer) @constant.numeric.integer
(bit_string_segment_option) @function.builtin
(escape_sequence) @constant.character.escape
((escape_sequence) @warning
 (#eq? @warning "\\e")) ; deprecated escape sequence
(string) @string

; Data constructors
(constructor_name) @constructor

; Type names
(type_identifier) @type
(remote_type_identifier) @type

(attribute_value (identifier) @constant)

; Attributes
(attribute
  "@" @attribute
  name: (identifier) @attribute)

; "Properties"
; Assumed to be intended to refer to a name for a field; something that comes
; before ":" or after "."
; e.g. record field names, tuple indices, names for named arguments, etc
(tuple_access
  index: (integer) @variable.other.member)
(label) @variable.other.member

; Functions
((binary_expression
   operator: "|>"
   right: (identifier) @function)
 (#is-not? local))
((function_call
   function: (identifier) @function)
 (#is-not? local))
(function_parameter
  name: (identifier) @variable.parameter)
(external_function
  name: (identifier) @function)
(function
  name: (identifier) @function)
(unqualified_import (type_identifier) @constructor)
(unqualified_import "type" (type_identifier) @type)
(unqualified_import (identifier) @function)

; Modules
((field_access
  record: (identifier) @namespace
  field: (label) @function)
 (#is-not? local))
(remote_constructor_name
  module: (identifier) @namespace)
(remote_type_identifier
  module: (identifier) @namespace)
(import alias: (identifier) @namespace)
(module) @namespace

; Constants
(constant
  name: (identifier) @constant)

; Comments
(comment) @comment
(statement_comment) @comment
(module_comment) @comment