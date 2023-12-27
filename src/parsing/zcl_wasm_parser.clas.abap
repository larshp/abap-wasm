CLASS zcl_wasm_parser DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS parse
      IMPORTING
        !iv_wasm         TYPE xstring
      RETURNING
        VALUE(ro_module) TYPE REF TO zcl_wasm_module .

    METHODS parse_instructions
      IMPORTING
        !io_body        TYPE REF TO zcl_wasm_binary_stream
      EXPORTING
        ev_last_opcode  TYPE zif_wasm_opcodes=>ty_opcode
        et_instructions TYPE zif_wasm_instruction=>ty_list .
  PROTECTED SECTION.

    CONSTANTS:
* Note that these constants are not structured as they contain JS keywords
      gc_section_custom   TYPE x LENGTH 1 VALUE '00' ##NO_TEXT.
    CONSTANTS:
      gc_section_type     TYPE x LENGTH 1 VALUE '01' ##NO_TEXT.
    CONSTANTS:
      gc_section_import   TYPE x LENGTH 1 VALUE '02' ##NO_TEXT.
    CONSTANTS:
      gc_section_function TYPE x LENGTH 1 VALUE '03' ##NO_TEXT.
    CONSTANTS:
      gc_section_table    TYPE x LENGTH 1 VALUE '04' ##NO_TEXT.
    CONSTANTS:
      gc_section_memory   TYPE x LENGTH 1 VALUE '05' ##NO_TEXT.
    CONSTANTS:
      gc_section_global   TYPE x LENGTH 1 VALUE '06' ##NO_TEXT.
    CONSTANTS:
      gc_section_export   TYPE x LENGTH 1 VALUE '07' ##NO_TEXT.
    CONSTANTS:
      gc_section_start    TYPE x LENGTH 1 VALUE '08' ##NO_TEXT.
    CONSTANTS:
      gc_section_element  TYPE x LENGTH 1 VALUE '09' ##NO_TEXT.
    CONSTANTS:
      gc_section_code     TYPE x LENGTH 1 VALUE '0A' ##NO_TEXT.
    CONSTANTS:
      gc_section_data     TYPE x LENGTH 1 VALUE '0B' ##NO_TEXT.

    METHODS parse_code
      IMPORTING
        !io_body          TYPE REF TO zcl_wasm_binary_stream
      RETURNING
        VALUE(rt_results) TYPE zcl_wasm_module=>ty_codes .

    METHODS parse_type
      IMPORTING
        !io_body          TYPE REF TO zcl_wasm_binary_stream
      RETURNING
        VALUE(rt_results) TYPE zcl_wasm_module=>ty_types .
    METHODS parse_function
      IMPORTING
        !io_body          TYPE REF TO zcl_wasm_binary_stream
      RETURNING
        VALUE(rt_results) TYPE zcl_wasm_module=>ty_functions .
    METHODS parse_export
      IMPORTING
        !io_body          TYPE REF TO zcl_wasm_binary_stream
      RETURNING
        VALUE(rt_results) TYPE zcl_wasm_module=>ty_exports .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_wasm_parser IMPLEMENTATION.


  METHOD parse.

    CONSTANTS lc_magic   TYPE x LENGTH 4 VALUE '0061736D'.
    CONSTANTS lc_version TYPE x LENGTH 4 VALUE '01000000'.

    DATA(lo_stream) = NEW zcl_wasm_binary_stream( iv_wasm ).

* https://webassembly.github.io/spec/core/binary/modules.html#binary-module
    ASSERT lo_stream->shift( 4 ) = lc_magic.
    ASSERT lo_stream->shift( 4 ) = lc_version.

    WHILE lo_stream->get_length( ) > 0.
* https://webassembly.github.io/spec/core/binary/modules.html#sections
      DATA(lv_section) = lo_stream->shift( 1 ).
      DATA(lv_length) = lo_stream->shift_u32( ).
      DATA(lo_body) = NEW zcl_wasm_binary_stream( lo_stream->shift( lv_length ) ).

      " WRITE: / 'section:', lv_section.
      " WRITE: / 'body:', lo_body->get_data( ).

      CASE lv_section.
        WHEN gc_section_custom.
* https://webassembly.github.io/spec/core/binary/modules.html#binary-customsec
* "ignored by the WebAssembly semantics"
          CONTINUE.
        WHEN gc_section_type.
          DATA(lt_types) = parse_type( lo_body ).
        WHEN gc_section_import.
          ASSERT 0 = 'todo'.
        WHEN gc_section_function.
          DATA(lt_functions) = parse_function( lo_body ).
        WHEN gc_section_table.
          ASSERT 0 = 'todo'.
        WHEN gc_section_memory.
          ASSERT 0 = 'todo'.
        WHEN gc_section_global.
          ASSERT 0 = 'todo'.
        WHEN gc_section_export.
          DATA(lt_exports) = parse_export( lo_body ).
        WHEN gc_section_start.
          ASSERT 0 = 'todo'.
        WHEN gc_section_element.
          ASSERT 0 = 'todo'.
        WHEN gc_section_code.
          DATA(lt_codes) = parse_code( lo_body ).
        WHEN gc_section_data.
          ASSERT 0 = 'todo'.
        WHEN OTHERS.
          ASSERT 0 = 1.
      ENDCASE.
    ENDWHILE.

    ro_module = NEW #(
      it_types     = lt_types
      it_codes     = lt_codes
      it_exports   = lt_exports
      it_functions = lt_functions ).

  ENDMETHOD.


  METHOD parse_code.

* https://webassembly.github.io/spec/core/binary/modules.html#binary-codesec

    DO io_body->shift_int( ) TIMES.

      DATA(lv_code_size) = io_body->shift_int( ).

      DATA(lo_code) = NEW zcl_wasm_binary_stream( io_body->shift( lv_code_size ) ).

      DATA(lv_locals_count) = lo_code->shift_int( ).
      ASSERT lv_locals_count = 0. " todo

      parse_instructions(
        EXPORTING io_body         = lo_code
        IMPORTING et_instructions = DATA(lt_instructions) ).

      APPEND VALUE #( instructions2 = lt_instructions ) TO rt_results.

    ENDDO.

  ENDMETHOD.

  METHOD parse_instructions.

    WHILE io_body->get_length( ) > 0.
      DATA(lv_opcode) = io_body->shift( 1 ).
      ev_last_opcode = lv_opcode.
      CASE lv_opcode.
        WHEN zif_wasm_opcodes=>c_opcodes-local_get.
          APPEND zcl_wasm_local_get=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_eqz.
          APPEND zcl_wasm_i32_eqz=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_eq.
          APPEND zcl_wasm_i32_eq=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_ne.
          APPEND zcl_wasm_i32_ne=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_lt_s.
          APPEND zcl_wasm_i32_lt_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_lt_u.
          APPEND zcl_wasm_i32_lt_u=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_gt_s.
          APPEND zcl_wasm_i32_gt_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_gt_u.
          APPEND zcl_wasm_i32_gt_u=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_le_s.
          APPEND zcl_wasm_i32_le_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_le_u.
          APPEND zcl_wasm_i32_le_u=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_ge_s.
          APPEND zcl_wasm_i32_ge_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_ge_u.
          APPEND zcl_wasm_i32_ge_u=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-block.
          APPEND zcl_wasm_block=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-nop.
          APPEND zcl_wasm_nop=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-loop.
          APPEND zcl_wasm_loop=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_add.
          APPEND zcl_wasm_i32_add=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_sub.
          APPEND zcl_wasm_i32_sub=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_const.
          APPEND zcl_wasm_i32_const=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i64_const.
          APPEND zcl_wasm_i64_const=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-select.
          APPEND zcl_wasm_select=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_clz.
          APPEND zcl_wasm_i32_clz=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_ctz.
          APPEND zcl_wasm_i32_ctz=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_popcnt.
          APPEND zcl_wasm_i32_popcnt=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_mul.
          APPEND zcl_wasm_i32_mul=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_div_s.
          APPEND zcl_wasm_i32_div_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_div_u.
          APPEND zcl_wasm_i32_div_u=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_rem_s.
          APPEND zcl_wasm_i32_rem_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_rem_u.
          APPEND zcl_wasm_i32_rem_u=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_and.
          APPEND zcl_wasm_i32_and=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_or.
          APPEND zcl_wasm_i32_or=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_xor.
          APPEND zcl_wasm_i32_xor=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_shl.
          APPEND zcl_wasm_i32_shl=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_shr_s.
          APPEND zcl_wasm_i32_shr_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_shr_u.
          APPEND zcl_wasm_i32_shr_u=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_rotl.
          APPEND zcl_wasm_i32_rotl=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_rotr.
          APPEND zcl_wasm_i32_rotr=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_extend8_s.
          APPEND zcl_wasm_i32_extend8_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_extend16_s.
          APPEND zcl_wasm_i32_extend16_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-call.
          APPEND zcl_wasm_call=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-if_.
          APPEND zcl_wasm_if=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-return_.
          APPEND zcl_wasm_return=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-unreachable.
          APPEND zcl_wasm_unreachable=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_load.
          APPEND zcl_wasm_i32_load=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i64_load.
          APPEND zcl_wasm_i64_load=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-f32_load.
          APPEND zcl_wasm_f32_load=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-f64_load.
          APPEND zcl_wasm_f64_load=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_load8_s.
          APPEND zcl_wasm_i32_load8_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_load8_u.
          APPEND zcl_wasm_i32_load8_u=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_load16_s.
          APPEND zcl_wasm_i32_load16_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i32_load16_u.
          APPEND zcl_wasm_i32_load16_u=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i64_load8_s.
          APPEND zcl_wasm_i64_load8_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i64_load8_u.
          APPEND zcl_wasm_i64_load8_u=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i64_load16_s.
          APPEND zcl_wasm_i64_load16_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i64_load16_u.
          APPEND zcl_wasm_i64_load16_u=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i64_load32_s.
          APPEND zcl_wasm_i64_load32_s=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-i64_load32_u.
          APPEND zcl_wasm_i64_load32_u=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-drop.
          APPEND zcl_wasm_drop=>parse( io_body ) TO et_instructions.
        WHEN zif_wasm_opcodes=>c_opcodes-end.
          APPEND zcl_wasm_end=>parse( io_body ) TO et_instructions.
          RETURN.
        WHEN zif_wasm_opcodes=>c_opcodes-else_.
          RETURN.
        WHEN OTHERS.
          WRITE: / 'todoparser:', lv_opcode.
          ASSERT 1 = 'todo'.
      ENDCASE.
    ENDWHILE.

  ENDMETHOD.


  METHOD parse_export.

* https://webassembly.github.io/spec/core/binary/modules.html#binary-exportsec

    DATA ls_result TYPE zcl_wasm_module=>ty_export.

    DATA(lv_count) = io_body->shift_int( ).
    " WRITE: / 'exports:', lv_count.

    DO lv_count TIMES.
      ls_result-name = io_body->shift_utf8( ).
      ls_result-type = io_body->shift( 1 ).

      ASSERT ls_result-type = zcl_wasm_types=>c_export_type-func
        OR ls_result-type = zcl_wasm_types=>c_export_type-table
        OR ls_result-type = zcl_wasm_types=>c_export_type-mem
        OR ls_result-type = zcl_wasm_types=>c_export_type-global.

      ls_result-index = io_body->shift_int( ).

      APPEND ls_result TO rt_results.
    ENDDO.

  ENDMETHOD.


  METHOD parse_function.

* https://webassembly.github.io/spec/core/binary/modules.html#binary-funcsec

    DO io_body->shift_int( ) TIMES.
      APPEND io_body->shift_int( ) TO rt_results.
    ENDDO.

  ENDMETHOD.


  METHOD parse_type.

* https://webassembly.github.io/spec/core/binary/modules.html#type-section

    DO io_body->shift_int( ) TIMES.
      ASSERT io_body->shift( 1 ) = zcl_wasm_types=>c_function_type.

      APPEND VALUE #(
        parameter_types = io_body->shift( io_body->shift_int( ) )
        result_types    = io_body->shift( io_body->shift_int( ) )
        ) TO rt_results.
    ENDDO.

  ENDMETHOD.
ENDCLASS.
