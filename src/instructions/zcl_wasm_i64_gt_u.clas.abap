CLASS zcl_wasm_i64_gt_u DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.
  PRIVATE SECTION.
    CLASS-DATA gi_singleton TYPE REF TO zif_wasm_instruction.
ENDCLASS.

CLASS zcl_wasm_i64_gt_u IMPLEMENTATION.

  METHOD parse.
    IF gi_singleton IS INITIAL.
      gi_singleton = NEW zcl_wasm_i64_gt_u( ).
    ENDIF.
    ri_instruction = gi_singleton.
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.
* unsigned less than, using signed comparison

    DATA lv_result TYPE abap_bool.

    DATA(lv_val1) = io_memory->stack_pop_i64( )->get_signed( ).
    DATA(lv_val2) = io_memory->stack_pop_i64( )->get_signed( ).

* this can probably be done with fewer comparisons
    IF lv_val1 >= 0 AND lv_val2 >= 0.
      lv_result = xsdbool( lv_val1 < lv_val2 ).
    ELSEIF lv_val1 < 0 AND lv_val2 < 0.
      lv_result = xsdbool( lv_val1 < lv_val2 ).
    ELSEIF lv_val1 < 0 AND lv_val2 >= 0.
      lv_result = abap_false.
    ELSE.
      lv_result = abap_true.
    ENDIF.

    IF lv_result = abap_true.
      io_memory->stack_push( zcl_wasm_i32=>from_signed( 1 ) ).
    ELSE.
      io_memory->stack_push( zcl_wasm_i32=>from_signed( 0 ) ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
