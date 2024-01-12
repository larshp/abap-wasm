CLASS zcl_wasm_f32_trunc DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.
ENDCLASS.

CLASS zcl_wasm_f32_trunc IMPLEMENTATION.

  METHOD parse.
* todo: singletons?
    ri_instruction = NEW zcl_wasm_f32_trunc( ).
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.