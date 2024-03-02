CLASS zcl_wasm_f32_load DEFINITION PUBLIC.
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
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction
      RAISING zcx_wasm.

  PRIVATE SECTION.
    DATA mv_align TYPE int8.
    DATA mv_offset TYPE int8.
ENDCLASS.

CLASS zcl_wasm_f32_load IMPLEMENTATION.

  METHOD constructor.
    IF iv_align > zcl_wasm_memory=>c_alignment_32bit.
      RAISE EXCEPTION NEW zcx_wasm( text = 'alignment must not be larger than natural' ).
    ENDIF.

    mv_align  = iv_align.
    mv_offset = iv_offset.
  ENDMETHOD.

  METHOD parse.
    ri_instruction = NEW zcl_wasm_f32_load(
      iv_align  = io_body->shift_u32( )
      iv_offset = io_body->shift_u32( ) ).
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.

* https://webassembly.github.io/spec/core/exec/instructions.html#t-mathsf-xref-syntax-instructions-syntax-instr-memory-mathsf-load-xref-syntax-instructions-syntax-memarg-mathit-memarg-and-t-mathsf-xref-syntax-instructions-syntax-instr-memory-mathsf-load-n-mathsf-xref-syntax-instructions-syntax-sx-mathit-sx-xref-syntax-instructions-syntax-memarg-mathit-memarg

    CONSTANTS lc_length TYPE int8 VALUE 4.
    DATA lv_hex TYPE x LENGTH lc_length.
    DATA lv_int TYPE i.

    DATA(li_value) = io_memory->stack_pop( ).
    IF li_value->get_type( ) <> zcl_wasm_types=>c_value_type-i32.
      RAISE EXCEPTION NEW zcx_wasm( text = 'zcl_wasm_f32_load: expected i32' ).
    ENDIF.

    DATA(lv_i) = CAST zcl_wasm_i32( li_value )->get_signed( ).
    IF lv_i < 0.
      RAISE EXCEPTION NEW zcx_wasm( text = 'load: out of bounds' ).
    ENDIF.

    lv_hex = io_memory->get_linear( )->get(
      iv_length = lc_length
      iv_align  = mv_align
      iv_offset = mv_offset + lv_i ).

    IF lv_hex = '00000000'.
      io_memory->stack_push( zcl_wasm_f32=>from_float( 0 ) ).
    ELSE.
      RAISE EXCEPTION NEW zcx_wasm( text = 'todo, execute instruction zcl_wasm_f32_load' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
