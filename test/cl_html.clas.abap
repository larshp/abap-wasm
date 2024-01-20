CLASS cl_html DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS render RETURNING VALUE(rv_html) TYPE string.

    METHODS add_success
      IMPORTING
        iv_success TYPE string.

    METHODS add_warning
      IMPORTING
        iv_warning TYPE string.

    METHODS add_error
      IMPORTING
        iv_error TYPE string.

  PRIVATE SECTION.
    DATA mv_html TYPE string.
ENDCLASS.

CLASS cl_html IMPLEMENTATION.

  METHOD render.
    rv_html = '<html><body><h1>Hello World</h1></body></html>'.
  ENDMETHOD.

  METHOD add_warning.
    mv_html = mv_html && '<p style="background-color: yellow">' && iv_warning && |</p>\n|.
  ENDMETHOD.

  METHOD add_success.
    mv_html = mv_html && '<p style="background-color: green">' && iv_success && |</p>\n|.
  ENDMETHOD.

  METHOD add_error.
    mv_html = mv_html && '<p style="background-color: red">' && iv_error && |</p>\n|.
  ENDMETHOD.

ENDCLASS.
