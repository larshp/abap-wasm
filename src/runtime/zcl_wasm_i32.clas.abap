CLASS zcl_wasm_i32 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_wasm_value .

    CLASS-METHODS const_
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

* https://webassembly.github.io/spec/core/exec/instructions.html#t-mathsf-xref-syntax-instructions-syntax-binop-mathit-binop

    ASSERT io_memory->stack_length( ) >= 2.

    DATA(lo_val1) = CAST zcl_wasm_i32( io_memory->stack_pop( ) ).
    DATA(lo_val2) = CAST zcl_wasm_i32( io_memory->stack_pop( ) ).

    io_memory->stack_push( NEW zcl_wasm_i32( lo_val1->get_value( ) + lo_val2->get_value( ) ) ).

  ENDMETHOD.


  METHOD constructor.
    mv_value = iv_value.
  ENDMETHOD.


  METHOD const_.

* https://webassembly.github.io/spec/core/exec/instructions.html#t-mathsf-xref-syntax-instructions-syntax-instr-numeric-mathsf-const-c

    io_memory->stack_push( NEW zcl_wasm_i32( iv_value ) ).

  ENDMETHOD.


  METHOD get_value.

    rv_value = mv_value.

  ENDMETHOD.


  METHOD lt_s.

* https://webassembly.github.io/spec/core/exec/instructions.html#t-mathsf-xref-syntax-instructions-syntax-relop-mathit-relop

* signed compare

    ASSERT io_memory->stack_length( ) >= 2.

    DATA(lo_val1) = CAST zcl_wasm_i32( io_memory->stack_pop( ) ).
    DATA(lo_val2) = CAST zcl_wasm_i32( io_memory->stack_pop( ) ).

    DATA(lv_result) = 0.
    IF lo_val1->get_value( ) > lo_val2->get_value( ).
      lv_result = 1.
    ENDIF.

    io_memory->stack_push( NEW zcl_wasm_i32( lv_result ) ).

  ENDMETHOD.


  METHOD sub.

* https://webassembly.github.io/spec/core/exec/instructions.html#t-mathsf-xref-syntax-instructions-syntax-binop-mathit-binop

    ASSERT io_memory->stack_length( ) >= 2.

    DATA(lo_val1) = CAST zcl_wasm_i32( io_memory->stack_pop( ) ).
    DATA(lo_val2) = CAST zcl_wasm_i32( io_memory->stack_pop( ) ).

    io_memory->stack_push( NEW zcl_wasm_i32( lo_val2->get_value( ) - lo_val1->get_value( ) ) ).

  ENDMETHOD.


  METHOD zif_wasm_value~get_type.

    rv_type = zcl_wasm_types=>c_value_type-i32.

  ENDMETHOD.
ENDCLASS.
