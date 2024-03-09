CLASS zcl_wasm_import_section DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS parse
      IMPORTING
        !io_body  TYPE REF TO zcl_wasm_binary_stream
      EXPORTING
        eo_import_section TYPE REF TO zcl_wasm_import_section
      CHANGING
        ct_functions TYPE zcl_wasm_module=>ty_functions
      RAISING
        zcx_wasm.

    METHODS import
      IMPORTING
        io_memory  TYPE REF TO zcl_wasm_memory
      RAISING
        zcx_wasm.

    TYPES: BEGIN OF ty_import,
             module TYPE string,
             name   TYPE string,
             type   TYPE x LENGTH 1,
             BEGIN OF func,
               typeidx TYPE i,
             END OF func,
             BEGIN OF table,
               reftype TYPE x LENGTH 1,
               limit   TYPE x LENGTH 1,
               min     TYPE i,
               max     TYPE i,
             END OF table,
             BEGIN OF mem,
               limit TYPE x LENGTH 1,
               min   TYPE i,
               max   TYPE i,
             END OF mem,
             BEGIN OF global,
               valtype TYPE x LENGTH 1,
               mut     TYPE x LENGTH 1,
             END OF global,
           END OF ty_import.
    TYPES ty_imports_tt TYPE STANDARD TABLE OF ty_import WITH DEFAULT KEY.

    METHODS constructor
      IMPORTING
        it_imports TYPE ty_imports_tt OPTIONAL.
  PRIVATE SECTION.
    CONSTANTS: BEGIN OF c_importdesc,
                 func   TYPE x VALUE '00',
                 table  TYPE x VALUE '01',
                 mem    TYPE x VALUE '02',
                 global TYPE x VALUE '03',
               END OF c_importdesc.

    DATA mt_imports TYPE ty_imports_tt.
ENDCLASS.

CLASS zcl_wasm_import_section IMPLEMENTATION.

  METHOD constructor.
    mt_imports = it_imports.
  ENDMETHOD.

  METHOD parse.

* https://webassembly.github.io/spec/core/binary/modules.html#binary-importsec
* https://webassembly.github.io/spec/core/syntax/modules.html#syntax-import

    DATA lt_imports TYPE ty_imports_tt.
    DATA ls_import LIKE LINE OF lt_imports.

    DO io_body->shift_u32( ) TIMES.
      CLEAR ls_import.

      ls_import-module = io_body->shift_utf8( ).
      ls_import-name = io_body->shift_utf8( ).
      ls_import-type = io_body->shift( 1 ).

      CASE ls_import-type.
        WHEN c_importdesc-func.
          ls_import-func-typeidx = io_body->shift_u32( ).
          INSERT VALUE #(
            typeidx = ls_import-func-typeidx
            codeidx = -1 ) INTO TABLE ct_functions.
        WHEN c_importdesc-table.
          ls_import-table-reftype = io_body->shift( 1 ).
          ls_import-table-limit = io_body->shift( 1 ).
          ls_import-table-min = io_body->shift_u32( ).
          CASE ls_import-table-limit.
            WHEN '00'.
              ls_import-table-max = 0.
            WHEN '01'.
              ls_import-table-max = io_body->shift_u32( ).
            WHEN OTHERS.
              RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = |parse_import: malformed import kind|.
          ENDCASE.
        WHEN c_importdesc-mem.
          ls_import-mem-limit = io_body->shift( 1 ).
          ls_import-mem-min = io_body->shift_u32( ).
          CASE ls_import-mem-limit.
            WHEN '00'.
              ls_import-mem-max = 0.
            WHEN '01'.
              ls_import-mem-max = io_body->shift_u32( ).
            WHEN OTHERS.
              RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = |parse_import: malformed import kind|.
          ENDCASE.
        WHEN c_importdesc-global.
          ls_import-global-valtype = io_body->shift( 1 ).
          ls_import-global-mut = io_body->shift( 1 ).
        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = |parse_import: malformed import kind|.
      ENDCASE.

      INSERT ls_import INTO TABLE lt_imports.
    ENDDO.

    eo_import_section = NEW #( lt_imports ).

  ENDMETHOD.

  METHOD import.

    DATA li_value TYPE REF TO zif_wasm_value.

    LOOP AT mt_imports INTO DATA(ls_import).
      CASE ls_import-type.
        WHEN c_importdesc-func.
          CONTINUE. " nothing here
        WHEN c_importdesc-table.
* todo
        WHEN c_importdesc-mem.
* todo
        WHEN c_importdesc-global.
* todo, handle ls_import-global-mut
          CASE ls_import-global-valtype.
            WHEN zcl_wasm_types=>c_value_type-i32.
              li_value = NEW zcl_wasm_i32( ).
            WHEN zcl_wasm_types=>c_value_type-i64.
              li_value = NEW zcl_wasm_i64( ).
            WHEN zcl_wasm_types=>c_value_type-f32.
              li_value = NEW zcl_wasm_f32( ).
            WHEN zcl_wasm_types=>c_value_type-f64.
              li_value = NEW zcl_wasm_f64( ).
            WHEN OTHERS.
              RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = |import: unknown global import type|.
          ENDCASE.
          io_memory->get_globals( )->global_append( li_value ).
        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = |import: unknown import type|.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
