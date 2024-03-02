CLASS zcl_wasm_i32_shr_s DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.
  PRIVATE SECTION.
    CLASS-DATA gi_singleton TYPE REF TO zif_wasm_instruction.
ENDCLASS.

CLASS zcl_wasm_i32_shr_s IMPLEMENTATION.

  METHOD parse.
    IF gi_singleton IS INITIAL.
      gi_singleton = NEW zcl_wasm_i32_shr_s( ).
    ENDIF.
    ri_instruction = gi_singleton.
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.
* https://webassembly.github.io/spec/core/exec/numerics.html#xref-exec-numerics-op-ishr-s-mathrm-ishr-s-n-i-1-i-2
* shift right signed

    DATA(lv_count) = io_memory->stack_pop_i32( )->get_signed( ) MOD 32.

    DATA(li_val) = io_memory->stack_pop_i32( ).
    DATA(lv_int) = li_val->get_signed( ).

    IF lv_count < 0.
      RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = |zcl_wasm_i32_shr_s, count negative|.
    ELSEIF lv_count > 100.
      RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = |zcl_wasm_i32_shr_s, more than 100 bits|.
    ENDIF.

    IF lv_count = 0.
      io_memory->stack_push( li_val ).
    ELSE.
      DO lv_count TIMES.
        lv_int = lv_int DIV 2.
      ENDDO.
      io_memory->stack_push( zcl_wasm_i32=>from_signed( lv_int ) ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
