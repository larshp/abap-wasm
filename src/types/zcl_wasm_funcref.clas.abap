CLASS zcl_wasm_funcref DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_value .
    METHODS constructor IMPORTING iv_address TYPE int8.
    METHODS is_null RETURNING VALUE(rv_null) TYPE abap_bool.
  PRIVATE SECTION.
    DATA mv_address TYPE int8.
ENDCLASS.

CLASS zcl_wasm_funcref IMPLEMENTATION.

  METHOD zif_wasm_value~human_readable_value.
    rv_string = |funcref: todo|.
  ENDMETHOD.

  METHOD constructor.
    mv_address = iv_address.
  ENDMETHOD.

  METHOD zif_wasm_value~get_type.
    rv_type = zcl_wasm_types=>c_reftype-funcref.
  ENDMETHOD.

  METHOD is_null.
    rv_null = xsdbool( mv_address < 0 ).
  ENDMETHOD.

ENDCLASS.
