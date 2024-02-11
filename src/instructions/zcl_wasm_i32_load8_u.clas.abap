CLASS zcl_wasm_i32_load8_u DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    METHODS constructor
      IMPORTING
        iv_align  TYPE int8
        iv_offset TYPE int8
      RAISING
        zcx_wasm.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.

  PRIVATE SECTION.
    DATA mv_align  TYPE int8.
    DATA mv_offset TYPE int8.
ENDCLASS.

CLASS zcl_wasm_i32_load8_u IMPLEMENTATION.

  METHOD constructor.
    IF iv_align > zcl_wasm_memory=>c_alignment_8bit.
      RAISE EXCEPTION NEW zcx_wasm( text = 'alignment must not be larger than natural' ).
    ENDIF.

    mv_align  = iv_align.
    mv_offset = iv_offset.
  ENDMETHOD.

  METHOD parse.
    ri_instruction = NEW zcl_wasm_i32_load8_u(
      iv_align  = io_body->shift_u32( )
      iv_offset = io_body->shift_u32( ) ).
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.
    CONSTANTS lc_length TYPE int8 VALUE 1.
    DATA lv_hex TYPE x LENGTH lc_length.
    DATA lv_int TYPE i.

    DATA(lv_i) = io_memory->stack_pop_i32( )->get_signed( ).
    lv_hex = io_memory->linear_get(
      iv_length = lc_length
      iv_align  = mv_align
      iv_offset = mv_offset + lv_i ).

    lv_int = lv_hex.
    io_memory->stack_push( zcl_wasm_i32=>from_signed( lv_int ) ).
  ENDMETHOD.

ENDCLASS.
