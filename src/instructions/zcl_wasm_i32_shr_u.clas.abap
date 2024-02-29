CLASS zcl_wasm_i32_shr_u DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.
  PRIVATE SECTION.
    CLASS-DATA gi_singleton TYPE REF TO zif_wasm_instruction.
ENDCLASS.

CLASS zcl_wasm_i32_shr_u IMPLEMENTATION.

  METHOD parse.
    IF gi_singleton IS INITIAL.
      gi_singleton = NEW zcl_wasm_i32_shr_u( ).
    ENDIF.
    ri_instruction = gi_singleton.
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.
* shift right unsigned

    DATA(lv_count) = io_memory->stack_pop_i32( )->get_signed( ).
    DATA(lv_int) = io_memory->stack_pop_i32( )->get_unsigned( ).

    IF lv_count < 0 OR lv_count > 100.
      RAISE EXCEPTION NEW zcx_wasm( text = |shift, unexpected count| ).
    ENDIF.

    DO lv_count TIMES.
      lv_int = lv_int DIV 2.
    ENDDO.

    io_memory->stack_push( zcl_wasm_i32=>from_unsigned( lv_int ) ).

  ENDMETHOD.

ENDCLASS.
