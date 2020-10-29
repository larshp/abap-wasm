
CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS:
      add FOR TESTING,
      const_ FOR TESTING.

ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD const_.

    DATA(lo_memory) = NEW zcl_wasm_memory( ).

    zcl_wasm_i32=>const_( io_memory = lo_memory
                          iv_value  = 2 ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_memory->stack_length( )
      exp = 1 ).

  ENDMETHOD.

  METHOD add.

    DATA(lo_memory) = NEW zcl_wasm_memory( ).

    lo_memory->stack_push( NEW zcl_wasm_i32( 2 ) ).
    lo_memory->stack_push( NEW zcl_wasm_i32( 3 ) ).

    zcl_wasm_i32=>add( lo_memory ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_memory->stack_length( )
      exp = 1 ).

    DATA(li_pop) = lo_memory->stack_pop( ).

    cl_abap_unit_assert=>assert_equals(
      act = li_pop->get_type( )
      exp = zcl_wasm_types=>c_value_type-i32 ).

    DATA(lo_int) = CAST zcl_wasm_i32( li_pop ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_int->get_value( )
      exp = 5 ).

  ENDMETHOD.

ENDCLASS.
