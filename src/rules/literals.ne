# =============================================================
# Literals.
#
# https://dev.mysql.com/doc/refman/5.7/en/literals.html

O_LITERAL ->
    %K_TRUE               {% d => d[0].value %}
  | %K_FALSE              {% d => d[0].value %}
  | %K_NULL               {% d => d[0].value %}
  | %K_CURRENT_TIMESTAMP  {% d => d[0].value %}
  | %S_NUMBER             {% d => d[0].value %}
  | O_LITERAL_BIT         {% id %}
  | O_LITERAL_HEXA        {% id %}
  | O_LITERAL_DATETIME    {% id %}
  | O_LITERAL_STRING      {% id %}

# =============================================================
# String literals.
#
# https://dev.mysql.com/doc/refman/5.7/en/string-literals.html

O_LITERAL_STRING ->
    O_CONCAT_STRING
      {% id %}
  | %S_IDENTIFIER_UNQUOTED O_CONCAT_STRING
      {% d => d[0].value + d[1] %}
  | %S_LBRACE _ %S_IDENTIFIER_UNQUOTED _ O_CONCAT_STRING _ %S_RBRACE
      {% d => d[2].value + d[4] %}

O_CONCAT_STRING ->
    %S_DQUOTE_STRING
      (
          __ %S_DQUOTE_STRING {% d => d[1] %}
        | __ %S_SQUOTE_STRING {% d => d[1] %}
      ):*
      {% d => d[0].value + d[1].value %}
  | %S_SQUOTE_STRING
      (
          __ %S_DQUOTE_STRING {% d => d[1] %}
        | __ %S_SQUOTE_STRING {% d => d[1] %}
      ):*
      {% d => d[0].value + d[1].value %}

# =============================================================
# Datetime literals.
#
# https://dev.mysql.com/doc/refman/5.7/en/date-and-time-literals.html

O_LITERAL_DATETIME ->
  (
      %K_DATE
    | %K_TIME
    | %K_TIMESTAMP
  ) _
  ( %S_SQUOTE_STRING {% id %} | %S_DQUOTE_STRING {% id %} )
    {% d => d[1].value %}

# =============================================================
# Hexadecimal literals.
#
# https://dev.mysql.com/doc/refman/5.7/en/hexadecimal-literals.html

O_LITERAL_HEXA ->
    %S_IDENTIFIER_UNQUOTED %S_HEXA_FORMAT __ %K_COLLATE __ O_COLLATION
    {% d => d[1].value %}
  | %S_IDENTIFIER_UNQUOTED %S_HEXA_FORMAT
    {% d => d[1].value %}
  | %S_HEXA_FORMAT
    {% d => d[0].value %}

# =============================================================
# Bit literals.
#
# https://dev.mysql.com/doc/refman/5.7/en/bit-value-literals.html

O_LITERAL_BIT ->
    %S_IDENTIFIER_UNQUOTED %S_BIT_FORMAT __ %K_COLLATE __ O_COLLATION
    {% d => d[1].value %}
  | %S_IDENTIFIER_UNQUOTED %S_BIT_FORMAT
    {% d => d[1].value %}
  | %S_BIT_FORMAT
    {% d => d[0].value %}

