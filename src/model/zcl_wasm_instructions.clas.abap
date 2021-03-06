CLASS zcl_wasm_instructions DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES ty_instruction TYPE x LENGTH 1.
    TYPES ty_instructions TYPE STANDARD TABLE OF ty_instruction WITH DEFAULT KEY.

    CONSTANTS:
      BEGIN OF c_instructions,
* https://webassembly.github.io/spec/core/binary/instructions.html#control-instructions
        unreachable   TYPE ty_instruction VALUE '00',
        nop           TYPE ty_instruction VALUE '01',
        block         TYPE ty_instruction VALUE '02',
        loop          TYPE ty_instruction VALUE '03',
        if_           TYPE ty_instruction VALUE '04',
        else_         TYPE ty_instruction VALUE '05',
        end           TYPE ty_instruction VALUE '0B',
        br            TYPE ty_instruction VALUE '0C',
        br_if         TYPE ty_instruction VALUE '0D',
        br_table      TYPE ty_instruction VALUE '0E',
        return_       TYPE ty_instruction VALUE '0F',
        call          TYPE ty_instruction VALUE '10',
        call_indirect TYPE ty_instruction VALUE '11',
* https://webassembly.github.io/spec/core/binary/instructions.html#parametric-instructions
        drop          TYPE ty_instruction VALUE '1A',
        select        TYPE ty_instruction VALUE '1B',
* https://webassembly.github.io/spec/core/binary/instructions.html#variable-instructions
        local_get     TYPE ty_instruction VALUE '20',
        local_set     TYPE ty_instruction VALUE '21',
        local_tee     TYPE ty_instruction VALUE '22',
        global_get    TYPE ty_instruction VALUE '23',
        global_set    TYPE ty_instruction VALUE '24',
* https://webassembly.github.io/spec/core/binary/instructions.html#memory-instructions
* todo
* https://webassembly.github.io/spec/core/binary/instructions.html#numeric-instructions
        i32_const     TYPE ty_instruction VALUE '41',
        i64_const     TYPE ty_instruction VALUE '42',
        f32_const     TYPE ty_instruction VALUE '43',
        f64_const     TYPE ty_instruction VALUE '44',
        i32_eqz       TYPE ty_instruction VALUE '45',
        i32_eq        TYPE ty_instruction VALUE '46',
        i32_ne        TYPE ty_instruction VALUE '47',
        i32_lt_s      TYPE ty_instruction VALUE '48',
        i32_lt_u      TYPE ty_instruction VALUE '49',
        i32_gt_s      TYPE ty_instruction VALUE '4A',
        i32_gt_u      TYPE ty_instruction VALUE '4B',
        i32_le_s      TYPE ty_instruction VALUE '4C',
        i32_le_u      TYPE ty_instruction VALUE '4D',
        i32_ge_s      TYPE ty_instruction VALUE '4E',
        i32_ge_u      TYPE ty_instruction VALUE '4F',
        i64_eqz       TYPE ty_instruction VALUE '50',
        i64_eq        TYPE ty_instruction VALUE '51',
        i64_ne        TYPE ty_instruction VALUE '52',
        i64_lt_s      TYPE ty_instruction VALUE '53',
        i64_lt_u      TYPE ty_instruction VALUE '54',
        i64_gt_s      TYPE ty_instruction VALUE '55',
        i64_gt_u      TYPE ty_instruction VALUE '56',
        i64_le_s      TYPE ty_instruction VALUE '57',
        i64_le_u      TYPE ty_instruction VALUE '58',
        i64_ge_s      TYPE ty_instruction VALUE '59',
        i64_ge_u      TYPE ty_instruction VALUE '5A',
        f32_eq        TYPE ty_instruction VALUE '5B',
        f32_ne        TYPE ty_instruction VALUE '5C',
        f32_lt        TYPE ty_instruction VALUE '5D',
        f32_gt        TYPE ty_instruction VALUE '5E',
        f32_le        TYPE ty_instruction VALUE '5F',
        f32_ge        TYPE ty_instruction VALUE '60',
        f64_eq        TYPE ty_instruction VALUE '61',
        f64_ne        TYPE ty_instruction VALUE '62',
        f64_lt        TYPE ty_instruction VALUE '63',
        f64_gt        TYPE ty_instruction VALUE '64',
        f64_le        TYPE ty_instruction VALUE '65',
        f64_ge        TYPE ty_instruction VALUE '66',
        i32_clz       TYPE ty_instruction VALUE '67',
        i32_ctz       TYPE ty_instruction VALUE '68',
        i32_popcnt    TYPE ty_instruction VALUE '69',
        i32_add       TYPE ty_instruction VALUE '6A',
        i32_sub       TYPE ty_instruction VALUE '6B',
        i32_mul       TYPE ty_instruction VALUE '6C',
        i32_div_s     TYPE ty_instruction VALUE '6D',
        i32_div_u     TYPE ty_instruction VALUE '6E',
        i32_rem_s     TYPE ty_instruction VALUE '6F',
        i32_rem_u     TYPE ty_instruction VALUE '70',
        i32_and       TYPE ty_instruction VALUE '71',
        i32_or        TYPE ty_instruction VALUE '72',
        i32_xor       TYPE ty_instruction VALUE '73',
        i32_shl       TYPE ty_instruction VALUE '74',
        i32_shr_s     TYPE ty_instruction VALUE '75',
        i32_shr_u     TYPE ty_instruction VALUE '76',
        i32_rotl      TYPE ty_instruction VALUE '77',
        i32_rotr      TYPE ty_instruction VALUE '78',
* todo, more numeric instructions
      END OF c_instructions.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_WASM_INSTRUCTIONS IMPLEMENTATION.
ENDCLASS.
