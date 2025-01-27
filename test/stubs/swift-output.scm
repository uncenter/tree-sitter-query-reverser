; Upstream: https://github.com/alex-pinkus/tree-sitter-swift/blob/57c1c6d6ffa1c44b330182d41717e6fe37430704/queries/highlights.scm

(type_pack_expansion ["repeat" @keyword])
(type_parameter_pack ["each" @keyword])
(value_pack_expansion ["repeat" @keyword])
(value_parameter_pack ["each" @keyword])

; Operators
[
  "!"
  "?"
  "+"
  "-"
  "\\"
  "*"
  "/"
  "%"
  "="
  "+="
  "-="
  "*="
  "/="
  "<"
  ">"
  "<="
  ">="
  "++"
  "--"
  "&"
  "~"
  "%="
  "!="
  "!=="
  "=="
  "==="
  "??"

  "->"

  "..<"
  "..."
  (custom_operator)
] @operator

(simple_identifier) @variable

(type_annotation "!" @type)
"?" @type

; Basic literals
"nil" @constant.builtin
(boolean_literal) @constant.builtin.boolean
(real_literal) @constant.numeric.float
(integer_literal) @constant.numeric.integer
[
  (hex_literal)
  (oct_literal)
  (bin_literal)
] @constant.numeric

; Lambda literals
(lambda_literal "in" @keyword.operator)

; String literals
["\"" "\"\"\""] @string
(raw_str_interpolation_start) @punctuation.special
(raw_str_end_part) @string
(raw_str_part) @string
(multi_line_str_text) @string
(str_escaped_char) @string
(line_str_text) @string

; Comments
(multiline_comment) @comment
(comment) @comment

(statement_label) @label

["do" (throw_keyword) (catch_keyword)] @keyword

(ternary_expression
  ["?" ":"] @keyword.control.conditional)
"return" @keyword.return
(switch_entry (default_keyword) @keyword)
(switch_entry "fallthrough" @keyword)
(switch_entry "case" @keyword)
(switch_statement "switch" @keyword.control.conditional)
(if_statement "if" @keyword.control.conditional)
(guard_statement "guard" @keyword.control.conditional)

["let" "var"] @keyword

["while" "repeat" "continue" "break"] @keyword.control.repeat

; Statements
(as_operator) @keyword
(else) @keyword
(for_statement item: (simple_identifier) @variable)
(for_statement "in" @keyword.control.repeat)
(for_statement "for" @keyword.control.repeat)

(diagnostic) @function.macro
(directive) @function.macro

(try_operator ["try" @keyword])
(try_operator) @operator

(navigation_suffix
  (simple_identifier) @variable.other.member)

; Function calls
; defer { ... }
(call_expression (simple_identifier) @keyword (#eq? @keyword "defer"))
((navigation_expression
   (simple_identifier) @type) ; SomeType.method(): highlight SomeType as a type
   (#match? @type "^[A-Z]"))
(call_expression ; foo.bar.baz(): highlight the baz()
  (navigation_expression
    (navigation_suffix (simple_identifier) @function)))
; foo()
(call_expression (simple_identifier) @function)

(enum_entry "case" @keyword)

(import_declaration "import" @keyword.control.import)

(protocol_property_declaration (pattern (simple_identifier) @variable.other.member))
(class_body (property_declaration (pattern (simple_identifier) @variable.other.member)))

[
  (getter_specifier)
  (setter_specifier)
  (modify_specifier)
] @keyword

(precedence_group_attribute
 (simple_identifier) @keyword
 [(simple_identifier) @type
  (boolean_literal) @constant.builtin.boolean])
(precedence_group_declaration
 ["precedencegroup" @keyword]
 (simple_identifier) @type)

(existential_type ["any" @keyword])
(opaque_type ["some" @keyword])

[
  "typealias"
  "struct"
  "class"
  "actor"
  "enum"
  "protocol"
  "extension"
  "indirect"
  "nonisolated"
  "override"
  "convenience"
  "required"
  "mutating"
  "associatedtype"
  "package"
  "any"
] @keyword

(pattern bound_identifier: (simple_identifier)) @variable
(equality_constraint (identifier (simple_identifier) @variable.parameter))
(inheritance_constraint (identifier (simple_identifier) @variable.parameter))
(type_parameter (type_identifier) @variable.parameter)
(parameter name: (simple_identifier) @variable.parameter)
(parameter external_name: (simple_identifier) @variable.parameter)
(where_keyword) @keyword
"await" @keyword
"async" @keyword
(throws) @keyword

(deinit_declaration ["deinit" @constructor])
(init_declaration ["init" @constructor])
(protocol_function_declaration (simple_identifier) @function.method)
(function_declaration (simple_identifier) @function.method)

; Declarations
[
  (visibility_modifier)
  (member_modifier)
  (function_modifier)
  (property_modifier)
  (parameter_modifier)
  (inheritance_modifier)
] @keyword
"func" @keyword.function

; Identifiers
(user_type (type_identifier) @variable.builtin (#eq? @variable.builtin "Self"))
(self_expression) @variable.builtin
(type_identifier) @type
(attribute) @variable

["(" ")" "[" "]" "{" "}" "<" ">"] @punctuation.bracket
["." ";" ":" "," ] @punctuation.delimiter

(line_string_literal
  ["\\(" ")"] @punctuation.special)