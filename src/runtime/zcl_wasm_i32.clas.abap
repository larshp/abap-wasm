CLASS zcl_wasm_i32 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_wasm_value .

    CLASS-METHODS const
      IMPORTING
        !io_memory TYPE REF TO zcl_wasm_memory
        !iv_value  TYPE i .
    METHODS constructor
      IMPORTING
        !iv_value TYPE i .
    CLASS-METHODS add
      IMPORTING
        !io_memory TYPE REF TO zcl_wasm_memory .
    CLASS-METHODS lt_s
      IMPORTING
        !io_memory TYPE REF TO zcl_wasm_memory .
    CLASS-METHODS sub
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

    ASSERT io_memory->stack_length( ) >= 2.

    DATA(lo_val1) = CAST zcl_wasm_i32( io_memory->stack_pop( ) ).
    DATA(lo_val2) = CAST zcl_wasm_i32( io_memory->stack_pop( ) ).

    io_memory->stack_push( NEW zcl_wasm_i32( lo_val1->get_value( ) + lo_val2->get_value( ) ) ).

  ENDMETHOD.


  METHOD const.

* todo
    ASSERT 0 = 1.

  ENDMETHOD.


  METHOD constructor.
    mv_value = iv_value.
  ENDMETHOD.


  METHOD get_value.

    rv_value = mv_value.

  ENDMETHOD.


  METHOD lt_s.

* todo
    ASSERT 0 = 1.

  ENDMETHOD.


  METHOD sub.

    ASSERT io_memory->stack_length( ) >= 2.

    DATA(lo_val1) = CAST zcl_wasm_i32( io_memory->stack_pop( ) ).
    DATA(lo_val2) = CAST zcl_wasm_i32( io_memory->stack_pop( ) ).

    io_memory->stack_push( NEW zcl_wasm_i32( lo_val1->get_value( ) - lo_val2->get_value( ) ) ).

  ENDMETHOD.


  METHOD zif_wasm_value~get_type.

    rv_type = zcl_wasm_types=>c_value_type-i32.

  ENDMETHOD.
ENDCLASS.
