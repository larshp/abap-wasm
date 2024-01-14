CLASS zcl_wasm_memory_fill DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction.
ENDCLASS.

CLASS zcl_wasm_memory_fill IMPLEMENTATION.

  METHOD parse.
* todo: singletons?
    ri_instruction = NEW zcl_wasm_memory_fill( ).
    ASSERT io_body->shift( 1 ) = '00'.
  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.
    RAISE EXCEPTION NEW zcx_wasm( text = 'todo, execute instruction ' ).
  ENDMETHOD.

ENDCLASS.
