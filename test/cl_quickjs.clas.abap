CLASS cl_quickjs DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS run
      RETURNING VALUE(rv_json) TYPE string
      RAISING zcx_wasm.
ENDCLASS.

CLASS cl_quickjs IMPLEMENTATION.

  METHOD run.

* https://emscripten.org/docs/compiling/WebAssembly.html
* https://www.npmjs.com/package/@jitl/quickjs-wasmfile-release-sync
* https://www.npmjs.com/package/@jitl/quickjs-wasmfile-debug-sync

    DATA lv_hex TYPE xstring.

    WRITE '@KERNEL const fs = await import("fs");'.
    WRITE '@KERNEL lv_hex.set(fs.readFileSync("./node_modules/@jitl/quickjs-wasmfile-debug-sync/dist/emscripten-module.wasm").toString("hex").toUpperCase());'.

    GET RUN TIME FIELD DATA(lv_start).
    DATA(li_wasm) = zcl_wasm=>create_with_wasm( lv_hex ).
    GET RUN TIME FIELD DATA(lv_end).

    DATA(lv_runtime) = lv_end - lv_start.
    WRITE / |{ lv_runtime }ms parsing QuickJS|.

    rv_json = '{"runtime": "' && lv_runtime && '"}'.

* https://github.com/justjake/quickjs-emscripten/blob/main/c/interface.c

* JSRuntime *QTS_NewRuntime() {
    " DATA(lt_result) = li_wasm->execute_function_export( 'QTS_NewRuntime' ).

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
