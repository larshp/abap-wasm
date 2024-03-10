CLASS cl_quickjs DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS run
      IMPORTING
        iv_hex         TYPE xstring
      RETURNING
        VALUE(rv_json) TYPE string
      RAISING
        zcx_wasm.
ENDCLASS.

CLASS cl_quickjs IMPLEMENTATION.

  METHOD run.

* https://emscripten.org/docs/compiling/WebAssembly.html
* https://www.npmjs.com/package/@jitl/quickjs-wasmfile-release-sync
* https://www.npmjs.com/package/@jitl/quickjs-wasmfile-debug-sync

    DATA(lo_env) = NEW cl_quickjs_env( ).
    DATA(lo_wasi) = NEW cl_quickjs_wasi_preview( ).

    GET RUN TIME FIELD DATA(lv_start).
    DATA(li_wasm) = zcl_wasm=>create_with_wasm(
      iv_wasm    = iv_hex
      it_imports = VALUE #(
        ( name = 'env'                    module = lo_env )
        ( name = 'wasi_snapshot_preview1' module = lo_wasi ) ) ).
    GET RUN TIME FIELD DATA(lv_end).

    DATA(lv_runtime) = lv_end - lv_start.
    WRITE / |{ lv_runtime }ms parsing QuickJS|.

    rv_json = '{"runtime": "' && lv_runtime && '"}'.

* https://github.com/justjake/quickjs-emscripten/blob/main/c/interface.c

* JSRuntime *QTS_NewRuntime() {
*    DATA(lt_result) = li_wasm->execute_function_export( 'QTS_NewRuntime' ).
* todo: instantiate data, no linear memory

* JSContext *QTS_NewContext(JSRuntime *rt, IntrinsicsFlags intrinsics) {
* todo

* MaybeAsync(JSValue *) QTS_Eval(JSContext *ctx, BorrowedHeapChar *js_code, size_t js_code_length, const char *filename, EvalDetectModule detectModule, EvalFlags evalFlags) {
    " li_wasm->execute_function_export(
    "   iv_name       = 'QTS_Eval'
    "   it_parameters = VALUE #(
    "     ( zcl_wasm_i32=>from_signed( 0 ) )
    "     ( zcl_wasm_i32=>from_signed( 0 ) ) ) ).

  ENDMETHOD.

ENDCLASS.