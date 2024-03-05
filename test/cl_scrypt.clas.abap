CLASS cl_scrypt DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS run
      RETURNING VALUE(rv_json) TYPE string
      RAISING zcx_wasm.
ENDCLASS.

CLASS cl_scrypt IMPLEMENTATION.

  METHOD run.

    DATA lv_hex TYPE xstring.

    WRITE '@KERNEL const fs = await import("fs");'.
    WRITE '@KERNEL lv_hex.set(fs.readFileSync("./node_modules/scrypt-wasm/scrypt_wasm_bg.wasm").toString("hex").toUpperCase());'.
*    WRITE '@KERNEL lv_hex.set(fs.readFileSync("./test/denorg-scrypt.wasm").toString("hex").toUpperCase());'.

    GET RUN TIME FIELD DATA(lv_start).
    DATA(li_wasm) = zcl_wasm=>create_with_wasm( lv_hex ).
    GET RUN TIME FIELD DATA(lv_end).

    DATA(lv_runtime) = lv_end - lv_start.
    WRITE / |{ lv_runtime }ms parsing Scrypt-WASM|.

    rv_json = '{"runtime": "' && lv_runtime && '"}'.

**********************************************************************

    CONSTANTS lc_password TYPE xstring VALUE 'AABBCCAABBCC'.
    CONSTANTS lc_salt     TYPE xstring VALUE 'AABBCC'.
    CONSTANTS lc_length   TYPE i VALUE 32.
* result = 0fccffd6408ff51d1705dbf20d9d5ca448986927ec4114df16b925163a9b5b5d ?

**********************************************************************
* @denorg/scrypt

    " DATA(lt_results) = li_wasm->execute_function_export(
    "   iv_name       = '__wbindgen_add_to_stack_pointer'
    "   it_parameters = VALUE #( ( zcl_wasm_i32=>from_signed( -16 ) ) ) ).
    " DATA(lo_retptr) = CAST zcl_wasm_i32( lt_results[ 1 ] ).

* "scrypt_hash" function export takes 9 x i32 IMPORTING
    " li_wasm->execute_function_export(
    "   iv_name       = 'scrypt'
    "   it_parameters = VALUE #(
    "     ( lo_retptr )
    "     ( lo_password_ptr )
    "     ( zcl_wasm_i32=>from_signed( xstrlen( lc_password ) ) )
    "     ( lo_salt_ptr )
    "     ( zcl_wasm_i32=>from_signed( xstrlen( lc_salt ) ) )
    "     ( zcl_wasm_i32=>from_signed( 1024 ) )           " CPU/Memory cost parameter. Must be a power of 2 smaller than 2^(128*r/8)
    "     ( zcl_wasm_i32=>from_signed( 8 ) )              " block size
    "     ( zcl_wasm_i32=>from_signed( 16 ) )             " parallelism factor
    "     ( zcl_wasm_i32=>from_signed( lc_length ) ) ) ). " length (in bytes) of the output. Defaults to 32.

**********************************************************************
* scrypt-wasm

    li_wasm->instantiate( ).
    DATA(li_linear) = li_wasm->get_memory( )->get_linear( ).

    DATA(lt_results) = li_wasm->execute_function_export(
      iv_name       = '__wbindgen_malloc'
      it_parameters = VALUE #( ( zcl_wasm_i32=>from_signed( xstrlen( lc_password ) ) ) ) ).
    DATA(lo_password_ptr) = CAST zcl_wasm_i32( lt_results[ 1 ] ).
    WRITE / |\tpassword ptr: { lo_password_ptr->get_signed( ) }|.
    li_linear->set(
      iv_bytes  = lc_password
      iv_offset = CONV #( lo_password_ptr->get_signed( ) ) ).

    CLEAR lt_results.
    lt_results = li_wasm->execute_function_export(
      iv_name       = '__wbindgen_malloc'
      it_parameters = VALUE #( ( zcl_wasm_i32=>from_signed( xstrlen( lc_salt ) ) ) ) ).
    DATA(lo_salt_ptr) = CAST zcl_wasm_i32( lt_results[ 1 ] ).
    WRITE / |\tsalt ptr: { lo_salt_ptr->get_signed( ) }|.
    li_linear->set(
      iv_bytes  = lc_salt
      iv_offset = CONV #( lo_salt_ptr->get_signed( ) ) ).

    CLEAR lt_results.
    lt_results = li_wasm->execute_function_export( '__wbindgen_global_argument_ptr' ).
    DATA(lo_retptr) = CAST zcl_wasm_i32( lt_results[ 1 ] ).
    WRITE / |\tret ptr: { lo_retptr->get_signed( ) }|.

* "scrypt" function export takes 9 x i32 IMPORTING, no EXPORTING
    li_wasm->execute_function_export(
      iv_name       = 'scrypt'
      it_parameters = VALUE #(
        ( lo_retptr )
        ( lo_password_ptr )
        ( zcl_wasm_i32=>from_signed( xstrlen( lc_password ) ) )
        ( lo_salt_ptr )
        ( zcl_wasm_i32=>from_signed( xstrlen( lc_salt ) ) )
        ( zcl_wasm_i32=>from_signed( 1024 ) )
        ( zcl_wasm_i32=>from_signed( 8 ) )
        ( zcl_wasm_i32=>from_signed( 16 ) )
        ( zcl_wasm_i32=>from_signed( lc_length ) ) ) ).

    DATA(lv_result) = li_linear->get(
      iv_length = CONV #( lc_length )
      iv_offset = lo_retptr->get_signed( ) ).

    WRITE / lv_result.

  ENDMETHOD.

ENDCLASS.
