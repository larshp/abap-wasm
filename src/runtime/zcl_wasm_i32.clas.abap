CLASS zcl_wasm_i32 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_wasm_value .

    METHODS constructor
      IMPORTING
        !iv_value TYPE i .
    CLASS-METHODS add
      IMPORTING
        !io_memory TYPE REF TO zcl_wasm_memory .
    METHODS get_value
      RETURNING
        VALUE(rv_value) TYPE i .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mv_value TYPE i .
ENDCLASS.



CLASS ZCL_WASM_I32 IMPLEMENTATION.


  METHOD add.
* todo
  ENDMETHOD.


  METHOD constructor.
    mv_value = iv_value.
  ENDMETHOD.


  METHOD get_value.

    rv_value = mv_value.

  ENDMETHOD.


  METHOD zif_wasm_value~get_type.

    rv_type = zcl_wasm_value_types=>c_type-i32.

  ENDMETHOD.
ENDCLASS.
