INTERFACE zif_wasm_opcodes PUBLIC.

  TYPES ty_opcode TYPE x LENGTH 1.

  CONSTANTS:
      BEGIN OF c_opcodes,
* https://webassembly.github.io/spec/core/binary/instructions.html#control-instructions
        unreachable   TYPE ty_opcode VALUE '00',
        nop           TYPE ty_opcode VALUE '01',
        block         TYPE ty_opcode VALUE '02',
        loop          TYPE ty_opcode VALUE '03',
        if_           TYPE ty_opcode VALUE '04',
        else_         TYPE ty_opcode VALUE '05',
        end           TYPE ty_opcode VALUE '0B',
        br            TYPE ty_opcode VALUE '0C',
        br_if         TYPE ty_opcode VALUE '0D',
        br_table      TYPE ty_opcode VALUE '0E',
        return_       TYPE ty_opcode VALUE '0F',
        call          TYPE ty_opcode VALUE '10',
        call_indirect TYPE ty_opcode VALUE '11',
* https://webassembly.github.io/spec/core/binary/instructions.html#parametric-instructions
        drop          TYPE ty_opcode VALUE '1A',
        select        TYPE ty_opcode VALUE '1B',
* https://webassembly.github.io/spec/core/binary/instructions.html#variable-instructions
        local_get     TYPE ty_opcode VALUE '20',
        local_set     TYPE ty_opcode VALUE '21',
        local_tee     TYPE ty_opcode VALUE '22',
        global_get    TYPE ty_opcode VALUE '23',
        global_set    TYPE ty_opcode VALUE '24',
* https://webassembly.github.io/spec/core/binary/instructions.html#memory-instructions
* todo
* https://webassembly.github.io/spec/core/binary/instructions.html#numeric-instructions
        i32_const      TYPE ty_opcode VALUE '41',
        i64_const      TYPE ty_opcode VALUE '42',
        f32_const      TYPE ty_opcode VALUE '43',
        f64_const      TYPE ty_opcode VALUE '44',
        i32_eqz        TYPE ty_opcode VALUE '45',
        i32_eq         TYPE ty_opcode VALUE '46',
        i32_ne         TYPE ty_opcode VALUE '47',
        i32_lt_s       TYPE ty_opcode VALUE '48',
        i32_lt_u       TYPE ty_opcode VALUE '49',
        i32_gt_s       TYPE ty_opcode VALUE '4A',
        i32_gt_u       TYPE ty_opcode VALUE '4B',
        i32_le_s       TYPE ty_opcode VALUE '4C',
        i32_le_u       TYPE ty_opcode VALUE '4D',
        i32_ge_s       TYPE ty_opcode VALUE '4E',
        i32_ge_u       TYPE ty_opcode VALUE '4F',
        i64_eqz        TYPE ty_opcode VALUE '50',
        i64_eq         TYPE ty_opcode VALUE '51',
        i64_ne         TYPE ty_opcode VALUE '52',
        i64_lt_s       TYPE ty_opcode VALUE '53',
        i64_lt_u       TYPE ty_opcode VALUE '54',
        i64_gt_s       TYPE ty_opcode VALUE '55',
        i64_gt_u       TYPE ty_opcode VALUE '56',
        i64_le_s       TYPE ty_opcode VALUE '57',
        i64_le_u       TYPE ty_opcode VALUE '58',
        i64_ge_s       TYPE ty_opcode VALUE '59',
        i64_ge_u       TYPE ty_opcode VALUE '5A',
        f32_eq         TYPE ty_opcode VALUE '5B',
        f32_ne         TYPE ty_opcode VALUE '5C',
        f32_lt         TYPE ty_opcode VALUE '5D',
        f32_gt         TYPE ty_opcode VALUE '5E',
        f32_le         TYPE ty_opcode VALUE '5F',
        f32_ge         TYPE ty_opcode VALUE '60',
        f64_eq         TYPE ty_opcode VALUE '61',
        f64_ne         TYPE ty_opcode VALUE '62',
        f64_lt         TYPE ty_opcode VALUE '63',
        f64_gt         TYPE ty_opcode VALUE '64',
        f64_le         TYPE ty_opcode VALUE '65',
        f64_ge         TYPE ty_opcode VALUE '66',
        i32_clz        TYPE ty_opcode VALUE '67',
        i32_ctz        TYPE ty_opcode VALUE '68',
        i32_popcnt     TYPE ty_opcode VALUE '69',
        i32_add        TYPE ty_opcode VALUE '6A',
        i32_sub        TYPE ty_opcode VALUE '6B',
        i32_mul        TYPE ty_opcode VALUE '6C',
        i32_div_s      TYPE ty_opcode VALUE '6D',
        i32_div_u      TYPE ty_opcode VALUE '6E',
        i32_rem_s      TYPE ty_opcode VALUE '6F',
        i32_rem_u      TYPE ty_opcode VALUE '70',
        i32_and        TYPE ty_opcode VALUE '71',
        i32_or         TYPE ty_opcode VALUE '72',
        i32_xor        TYPE ty_opcode VALUE '73',
        i32_shl        TYPE ty_opcode VALUE '74',
        i32_shr_s      TYPE ty_opcode VALUE '75',
        i32_shr_u      TYPE ty_opcode VALUE '76',
        i32_rotl       TYPE ty_opcode VALUE '77',
        i32_rotr       TYPE ty_opcode VALUE '78',
        i32_extend8_s  TYPE ty_opcode VALUE 'C0',
        i32_extend16_s TYPE ty_opcode VALUE 'C1',
        i32_load       TYPE ty_opcode VALUE '28',
        i64_load       TYPE ty_opcode VALUE '29',
        f32_load       TYPE ty_opcode VALUE '2A',
        f64_load       TYPE ty_opcode VALUE '2B',
        i32_load8_s    TYPE ty_opcode VALUE '2C',
        i32_load8_u    TYPE ty_opcode VALUE '2D',
        i32_load16_s   TYPE ty_opcode VALUE '2E',
        i32_load16_u   TYPE ty_opcode VALUE '2F',
        i64_load8_s    TYPE ty_opcode VALUE '30',
        i64_load8_u    TYPE ty_opcode VALUE '31',
        i64_load16_s   TYPE ty_opcode VALUE '32',
        i64_load16_u   TYPE ty_opcode VALUE '33',
        i64_load32_s   TYPE ty_opcode VALUE '34',
        i64_load32_u   TYPE ty_opcode VALUE '35',
        i32_store      TYPE ty_opcode VALUE '36',
        i64_store      TYPE ty_opcode VALUE '37',
        f32_store      TYPE ty_opcode VALUE '38',
        f64_store      TYPE ty_opcode VALUE '39',
        memory_size    TYPE ty_opcode VALUE '3F',
        memory_grow    TYPE ty_opcode VALUE '40',
      END OF c_opcodes.

ENDINTERFACE.
