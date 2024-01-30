CLASS zcl_wasm_block DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_instruction.

    METHODS constructor
      IMPORTING
        iv_block_type TYPE xstring
        it_in         TYPE zif_wasm_instruction=>ty_list.

    CLASS-METHODS parse
      IMPORTING !io_body TYPE REF TO zcl_wasm_binary_stream
      RETURNING VALUE(ri_instruction) TYPE REF TO zif_wasm_instruction
      RAISING zcx_wasm.

  PRIVATE SECTION.
    DATA mv_block_type TYPE xstring.
    DATA mt_in         TYPE zif_wasm_instruction=>ty_list.

ENDCLASS.

CLASS zcl_wasm_block IMPLEMENTATION.

  METHOD constructor.
    mv_block_type = iv_block_type.
    mt_in         = it_in.
  ENDMETHOD.

  METHOD parse.

    DATA(lv_block_type) = io_body->shift( 1 ).
    DATA(lo_parser) = NEW zcl_wasm_parser( ).

    lo_parser->parse_instructions(
      EXPORTING
        io_body         = io_body
      IMPORTING
        ev_last_opcode  = DATA(lv_last_opcode)
        et_instructions = DATA(lt_in) ).

    IF lv_last_opcode <> zif_wasm_opcodes=>c_opcodes-end.
      RAISE EXCEPTION NEW zcx_wasm( text = |block, expected end| ).
    ENDIF.

    ri_instruction = NEW zcl_wasm_block(
      iv_block_type = lv_block_type
      it_in         = lt_in ).

  ENDMETHOD.

  METHOD zif_wasm_instruction~execute.
    RAISE EXCEPTION NEW zcx_wasm( text = 'todo, execute instruction zcl_wasm_block' ).
  ENDMETHOD.

ENDCLASS.
