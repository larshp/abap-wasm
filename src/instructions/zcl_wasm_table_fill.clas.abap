CLASS zcl_wasm_table_fill DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    METHODS constructor
      IMPORTING
        iv_tableidx TYPE int8.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.
  PRIVATE SECTION.
    DATA mv_tableidx TYPE int8.
ENDCLASS.

CLASS zcl_wasm_table_fill IMPLEMENTATION.

  METHOD constructor.
    mv_tableidx = iv_tableidx.
  ENDMETHOD.

  METHOD parse.
    ri_instruction = NEW zcl_wasm_table_fill(
      iv_tableidx = io_body->shift_u32( ) ).
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.
    RAISE EXCEPTION NEW zcx_wasm( text = 'todo, execute instruction zcl_wasm_table_fill' ).
  ENDMETHOD.

ENDCLASS.
