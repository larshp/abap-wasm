
CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA:
      mo_cut TYPE REF TO zcl_wast_parser.

    METHODS:
      setup,
      parse FOR TESTING.

ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD parse.

    DATA(lv_wast) =
      |(module\n| &&
      |  (func (export "addTwo") (param i32 i32) (result i32)\n| &&
      |    local.get 0\n| &&
      |    local.get 1\n| &&
      |    i32.add))|.

    DATA(lo_module) = mo_cut->parse( lv_wast ).

    cl_abap_unit_assert=>assert_not_initial( lo_module ).

    DATA(lt_functions) = lo_module->get_functions( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_functions )
      exp = 1 ).

    READ TABLE lt_functions INDEX 1 INTO DATA(lo_function).
    cl_abap_unit_assert=>assert_not_initial( lo_function ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_function->get_instructions( ) )
      exp = 3 ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_function->get_export_name( )
      exp = |addTwo| ).

  ENDMETHOD.

ENDCLASS.
