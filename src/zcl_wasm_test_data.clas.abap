CLASS zcl_wasm_test_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS wasm_add_two
      RETURNING
        VALUE(rv_xstr) TYPE xstring.

    CLASS-METHODS wasm_fibonacci
      RETURNING
        VALUE(rv_xstr) TYPE xstring.

    CLASS-METHODS wasm_factorial
      RETURNING
        VALUE(rv_xstr) TYPE xstring.

    CLASS-METHODS testsuite_i32
      RETURNING
        VALUE(rv_xstr) TYPE xstring.

    CLASS-METHODS testsuite_address
      RETURNING
        VALUE(rv_xstr) TYPE xstring.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_wasm_test_data IMPLEMENTATION.


  METHOD wasm_add_two.

* (module
*   (func $add (param $lhs i32) (param $rhs i32) (result i32)
*     get_local $lhs
*     get_local $rhs
*     i32.add)
*   (export "add" (func $add))
* )

    rv_xstr =
      |0061736D| && " magic
      |01000000| && " version
      |0107| && |0160027F7F017F| && " types
      |0302| && |0100| &&  " function
      |0707| && |01036164640000| && " export
      |0A09| && |010700| && |200020016A0B| && " code
      |001C| && |046E616D650106010003616464020D01000200036C68730103726873|.

  ENDMETHOD.


  METHOD wasm_fibonacci.

*(module
*  (type $t0 (func (param i32) (result i32)))
*  (func $fib (export "fib") (type $t0) (param $n i32) (result i32)
*    get_local $n
*    i32.const 2
*    i32.lt_s
*    if $I0
*      i32.const 1
*      return
*    end
*    get_local $n
*    i32.const 2
*    i32.sub
*    call $fib
*    get_local $n
*    i32.const 1
*    i32.sub
*    call $fib
*    i32.add
*    return))

    rv_xstr =
      |0061736D| && " magic
      |01000000| && " version
      |0106| && |0160017F017F| && " types
      |0302| && |0100| && " function
      |0707| && |01036669620000| && " export
      |0A1F| && |011D00| && " Start code section
        |2000| && " get local '00'
        |4102| && " const '02'
        |48| &&   " lt_s
        |0440| && " IF, blocktype = '40'
        |4101| && " const '01'
        |0F| &&   " return
        |0B| &&   " block end
        |2000| && " get local '00'
        |4102| && " const '02'
        |6B| &&   " subtract
        |1000| && " call '00'
        |2000| && " get local '00'
        |41016B10006A0F0B| &&
      |0015| && |046E616D650106010003666962020601000100016E|.

  ENDMETHOD.

  METHOD wasm_factorial.

    " (module
    " (func $fac (export "fac") (param i32) (result i32)
    "   local.get 0
    "   i32.const 1
    "   i32.lt_s
    "   if (result i32)
    "     i32.const 1
    "   else
    "     local.get 0
    "     local.get 0
    "     i32.const 1
    "     i32.sub
    "     call $fac
    "     i32.mul
    "   end))

    rv_xstr =
      |0061736D| && " magic
      |01000000| && " version
      |0106| && |0160017F017F| && " types
      |0302| && |0100| && " function
      |0707| && |01036661630000| && " export
      |0A19| && |011700| &&
      |2000| && " get local '00'
      |4101| && " const '01'
      |48| && " i32_lt_s
      |047F| && " if int32
      |410105| && " instructions 1
      |2000200041016B10006C0B| && " instructions 2
      |0B0012046E616D6501060100036661630203010000|.

  ENDMETHOD.

  METHOD testsuite_i32.

* https://github.com/WebAssembly/spec/blob/master/test/core/i32.wast

    rv_xstr =
      |0061736D01000000010C0260027F7F017F60017F017F03201F00000000000000| &&
      |00000000000000000101010101010000000000000000000007DE011F03616464| &&
      |0000037375620001036D756C0002056469765F730003056469765F7500040572| &&
      |656D5F7300050572656D5F75000603616E640007026F72000803786F72000903| &&
      |73686C000A057368725F73000B057368725F75000C04726F746C000D04726F74| &&
      |72000E03636C7A000F0363747A001006706F70636E74001109657874656E6438| &&
      |5F7300120A657874656E6431365F7300130365717A00140265710015026E6500| &&
      |16046C745F730017046C745F750018046C655F730019046C655F75001A046774| &&
      |5F73001B0467745F75001C0467655F73001D0467655F75001E0AED011F070020| &&
      |0020016A0B0700200020016B0B0700200020016C0B0700200020016D0B070020| &&
      |0020016E0B0700200020016F0B070020002001700B070020002001710B070020| &&
      |002001720B070020002001730B070020002001740B070020002001750B070020| &&
      |002001760B070020002001770B070020002001780B05002000670B0500200068| &&
      |0B05002000690B05002000C00B05002000C10B05002000450B07002000200146| &&
      |0B070020002001470B070020002001480B070020002001490B0700200020014C| &&
      |0B0700200020014D0B0700200020014A0B0700200020014B0B0700200020014E| &&
      |0B0700200020014F0B|.

  ENDMETHOD.

  METHOD testsuite_address.

* https://github.com/WebAssembly/spec/blob/master/test/core/address.wast

    rv_xstr =
      |0061736D01000000010A0260017F017F60017F00031F1E000000000000000000| &&
      |000000000000000000000000000000000101010101050301000107CD021E0838| &&
      |755F676F6F643100000838755F676F6F643200010838755F676F6F6433000208| &&
      |38755F676F6F643400030838755F676F6F643500040838735F676F6F64310005| &&
      |0838735F676F6F643200060838735F676F6F643300070838735F676F6F643400| &&
      |080838735F676F6F64350009093136755F676F6F6431000A093136755F676F6F| &&
      |6432000B093136755F676F6F6433000C093136755F676F6F6434000D09313675| &&
      |5F676F6F6435000E093136735F676F6F6431000F093136735F676F6F64320010| &&
      |093136735F676F6F64330011093136735F676F6F64340012093136735F676F6F| &&
      |643500130833325F676F6F643100140833325F676F6F643200150833325F676F| &&
      |6F643300160833325F676F6F643400170833325F676F6F643500180638755F62| &&
      |616400190638735F626164001A073136755F626164001B073136735F62616400| &&
      |1C0633325F626164001D0A8A021E070020002D00000B070020002D00000B0700| &&
      |20002D00010B070020002D00020B070020002D00190B070020002C00000B0700| &&
      |20002C00000B070020002C00010B070020002C00020B070020002C00190B0700| &&
      |20002F01000B070020002F00000B070020002F00010B070020002F01020B0700| &&
      |20002F01190B070020002E01000B070020002E00000B070020002E00010B0700| &&
      |20002E01020B070020002E01190B070020002802000B070020002800000B0700| &&
      |20002800010B070020002801020B070020002802190B0C0020002D00FFFFFFFF| &&
      |0F1A0B0C0020002C00FFFFFFFF0F1A0B0C0020002F01FFFFFFFF0F1A0B0C0020| &&
      |002E01FFFFFFFF0F1A0B0C0020002802FFFFFFFF0F1A0B0B20010041000B1A61| &&
      |62636465666768696A6B6C6D6E6F707172737475767778797A|.

  ENDMETHOD.

ENDCLASS.
