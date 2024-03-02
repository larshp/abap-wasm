CLASS zcl_wasm_instructions DEFINITION PUBLIC.
  PUBLIC SECTION.

    CLASS-METHODS parse
      IMPORTING
        !io_body        TYPE REF TO zcl_wasm_binary_stream
      EXPORTING
        ev_last_opcode  TYPE zif_wasm_opcodes=>ty_opcode
        et_instructions TYPE zif_wasm_instruction=>ty_list
      RAISING
        zcx_wasm.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS initialize.

    TYPES: BEGIN OF ty_opcodes,
             opcode TYPE x LENGTH 1,
             name   TYPE string,
           END OF ty_opcodes.
    CLASS-DATA gt_opcodes TYPE HASHED TABLE OF ty_opcodes WITH UNIQUE KEY opcode.
    CLASS-DATA gv_initialized TYPE abap_bool.
ENDCLASS.



CLASS zcl_wasm_instructions IMPLEMENTATION.


  METHOD initialize.

    DATA ls_row LIKE LINE OF gt_opcodes.

    ASSERT gv_initialized = abap_false.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-local_get.
    ls_row-name = 'ZCL_WASM_LOCAL_GET'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-local_set.
    ls_row-name = 'ZCL_WASM_LOCAL_SET'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-local_tee.
    ls_row-name = 'ZCL_WASM_LOCAL_TEE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_eqz.
    ls_row-name = 'ZCL_WASM_I32_EQZ'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_wrap_i64.
    ls_row-name = 'ZCL_WASM_I32_WRAP_I64'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_eq.
    ls_row-name = 'ZCL_WASM_I32_EQ'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_ne.
    ls_row-name = 'ZCL_WASM_I32_NE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_ne.
    ls_row-name = 'ZCL_WASM_F32_NE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_lt_s.
    ls_row-name = 'ZCL_WASM_I32_LT_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_lt_u.
    ls_row-name = 'ZCL_WASM_I32_LT_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_store16.
    ls_row-name = 'ZCL_WASM_I64_STORE16'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_ne.
    ls_row-name = 'ZCL_WASM_F64_NE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_lt.
    ls_row-name = 'ZCL_WASM_F64_LT'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_gt.
    ls_row-name = 'ZCL_WASM_F64_GT'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_ge.
    ls_row-name = 'ZCL_WASM_F64_GE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_le.
    ls_row-name = 'ZCL_WASM_F64_LE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_mul.
    ls_row-name = 'ZCL_WASM_I64_MUL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_sub.
    ls_row-name = 'ZCL_WASM_F32_SUB'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_eq.
    ls_row-name = 'ZCL_WASM_F64_EQ'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_le.
    ls_row-name = 'ZCL_WASM_F32_LE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_sub.
    ls_row-name = 'ZCL_WASM_I64_SUB'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_gt_s.
    ls_row-name = 'ZCL_WASM_I32_GT_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_le_u.
    ls_row-name = 'ZCL_WASM_I64_LE_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_gt_u.
    ls_row-name = 'ZCL_WASM_I32_GT_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_le_s.
    ls_row-name = 'ZCL_WASM_I32_LE_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_sqrt.
    ls_row-name = 'ZCL_WASM_F32_SQRT'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_eq.
    ls_row-name = 'ZCL_WASM_I64_EQ'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_ne.
    ls_row-name = 'ZCL_WASM_I64_NE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_lt_s.
    ls_row-name = 'ZCL_WASM_I64_LT_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_lt_u.
    ls_row-name = 'ZCL_WASM_I64_LT_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_gt_s.
    ls_row-name = 'ZCL_WASM_I64_GT_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_gt_u.
    ls_row-name = 'ZCL_WASM_I64_GT_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_le_s.
    ls_row-name = 'ZCL_WASM_I64_LE_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_ge_s.
    ls_row-name = 'ZCL_WASM_I64_GE_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_ge_u.
    ls_row-name = 'ZCL_WASM_I64_GE_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_ceil.
    ls_row-name = 'ZCL_WASM_F32_CEIL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_floor.
    ls_row-name = 'ZCL_WASM_F32_FLOOR'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_trunc.
    ls_row-name = 'ZCL_WASM_F32_TRUNC'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_nearest.
    ls_row-name = 'ZCL_WASM_F32_NEAREST'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_eq.
    ls_row-name = 'ZCL_WASM_F32_EQ'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_le_u.
    ls_row-name = 'ZCL_WASM_I32_LE_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_ge_s.
    ls_row-name = 'ZCL_WASM_I32_GE_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_ge_u.
    ls_row-name = 'ZCL_WASM_I32_GE_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-block.
    ls_row-name = 'ZCL_WASM_BLOCK'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-nop.
    ls_row-name = 'ZCL_WASM_NOP'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-loop.
    ls_row-name = 'ZCL_WASM_LOOP'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-br_if.
    ls_row-name = 'ZCL_WASM_BR_IF'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-global_get.
    ls_row-name = 'ZCL_WASM_GLOBAL_GET'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-global_set.
    ls_row-name = 'ZCL_WASM_GLOBAL_SET'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_const.
    ls_row-name = 'ZCL_WASM_F32_CONST'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_add.
    ls_row-name = 'ZCL_WASM_I32_ADD'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-br_table.
    ls_row-name = 'ZCL_WASM_BR_TABLE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-memory_size.
    ls_row-name = 'ZCL_WASM_MEMORY_SIZE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-memory_grow.
    ls_row-name = 'ZCL_WASM_MEMORY_GROW'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-call_indirect.
    ls_row-name = 'ZCL_WASM_CALL_INDIRECT'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_store.
    ls_row-name = 'ZCL_WASM_I32_STORE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_sub.
    ls_row-name = 'ZCL_WASM_I32_SUB'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_ctz.
    ls_row-name = 'ZCL_WASM_I64_CTZ'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_abs.
    ls_row-name = 'ZCL_WASM_F64_ABS'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_ceil.
    ls_row-name = 'ZCL_WASM_F64_CEIL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_floor.
    ls_row-name = 'ZCL_WASM_F64_FLOOR'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_trunc.
    ls_row-name = 'ZCL_WASM_F64_TRUNC'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_nearest.
    ls_row-name = 'ZCL_WASM_F64_NEAREST'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_sqrt.
    ls_row-name = 'ZCL_WASM_F64_SQRT'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_neg.
    ls_row-name = 'ZCL_WASM_F32_NEG'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_abs.
    ls_row-name = 'ZCL_WASM_F32_ABS'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_store.
    ls_row-name = 'ZCL_WASM_F64_STORE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_store8.
    ls_row-name = 'ZCL_WASM_I32_STORE8'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_copysign.
    ls_row-name = 'ZCL_WASM_F32_COPYSIGN'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_lt.
    ls_row-name = 'ZCL_WASM_F32_LT'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_ge.
    ls_row-name = 'ZCL_WASM_F32_GE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_store.
    ls_row-name = 'ZCL_WASM_I64_STORE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_neg.
    ls_row-name = 'ZCL_WASM_F64_NEG'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-br.
    ls_row-name = 'ZCL_WASM_BR'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_gt.
    ls_row-name = 'ZCL_WASM_F32_GT'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_const.
    ls_row-name = 'ZCL_WASM_F64_CONST'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_mul.
    ls_row-name = 'ZCL_WASM_F32_MUL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_min.
    ls_row-name = 'ZCL_WASM_F32_MIN'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_max.
    ls_row-name = 'ZCL_WASM_F32_MAX'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_div.
    ls_row-name = 'ZCL_WASM_F32_DIV'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_const.
    ls_row-name = 'ZCL_WASM_I32_CONST'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_const.
    ls_row-name = 'ZCL_WASM_I64_CONST'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-select.
    ls_row-name = 'ZCL_WASM_SELECT'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_clz.
    ls_row-name = 'ZCL_WASM_I32_CLZ'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_ctz.
    ls_row-name = 'ZCL_WASM_I32_CTZ'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_popcnt.
    ls_row-name = 'ZCL_WASM_I32_POPCNT'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_mul.
    ls_row-name = 'ZCL_WASM_I32_MUL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_div_s.
    ls_row-name = 'ZCL_WASM_I32_DIV_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_div_u.
    ls_row-name = 'ZCL_WASM_I32_DIV_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_div_s.
    ls_row-name = 'ZCL_WASM_I64_DIV_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_div_u.
    ls_row-name = 'ZCL_WASM_I64_DIV_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_rem_s.
    ls_row-name = 'ZCL_WASM_I64_REM_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_rem_u.
    ls_row-name = 'ZCL_WASM_I64_REM_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_and.
    ls_row-name = 'ZCL_WASM_I64_AND'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_or.
    ls_row-name = 'ZCL_WASM_I64_OR'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_xor.
    ls_row-name = 'ZCL_WASM_I64_XOR'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_shl.
    ls_row-name = 'ZCL_WASM_I64_SHL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_shr_s.
    ls_row-name = 'ZCL_WASM_I64_SHR_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_shr_u.
    ls_row-name = 'ZCL_WASM_I64_SHR_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_rotl.
    ls_row-name = 'ZCL_WASM_I64_ROTL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_rotr.
    ls_row-name = 'ZCL_WASM_I64_ROTR'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_rem_s.
    ls_row-name = 'ZCL_WASM_I32_REM_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_rem_u.
    ls_row-name = 'ZCL_WASM_I32_REM_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_and.
    ls_row-name = 'ZCL_WASM_I32_AND'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_or.
    ls_row-name = 'ZCL_WASM_I32_OR'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_xor.
    ls_row-name = 'ZCL_WASM_I32_XOR'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_shl.
    ls_row-name = 'ZCL_WASM_I32_SHL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_shr_s.
    ls_row-name = 'ZCL_WASM_I32_SHR_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_shr_u.
    ls_row-name = 'ZCL_WASM_I32_SHR_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_rotl.
    ls_row-name = 'ZCL_WASM_I32_ROTL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_rotr.
    ls_row-name = 'ZCL_WASM_I32_ROTR'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_extend8_s.
    ls_row-name = 'ZCL_WASM_I32_EXTEND8_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_extend16_s.
    ls_row-name = 'ZCL_WASM_I32_EXTEND16_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-call.
    ls_row-name = 'ZCL_WASM_CALL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-if_.
    ls_row-name = 'ZCL_WASM_IF'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-return_.
    ls_row-name = 'ZCL_WASM_RETURN'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-unreachable.
    ls_row-name = 'ZCL_WASM_UNREACHABLE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_load.
    ls_row-name = 'ZCL_WASM_I32_LOAD'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_trunc_f32_s.
    ls_row-name = 'ZCL_WASM_I32_TRUNC_F32_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_trunc_f32_u.
    ls_row-name = 'ZCL_WASM_I32_TRUNC_F32_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_trunc_f64_s.
    ls_row-name = 'ZCL_WASM_I32_TRUNC_F64_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_trunc_f64_u.
    ls_row-name = 'ZCL_WASM_I32_TRUNC_F64_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_extend_i32_s.
    ls_row-name = 'ZCL_WASM_I64_EXTEND_I32_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_reinterpret_f32.
    ls_row-name = 'ZCL_WASM_I32_REINTERPRET_F32'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_reinterpret_f64.
    ls_row-name = 'ZCL_WASM_I64_REINTERPRET_F64'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_reinterpret_i32.
    ls_row-name = 'ZCL_WASM_F32_REINTERPRET_I32'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_reinterpret_i64.
    ls_row-name = 'ZCL_WASM_F64_REINTERPRET_I64'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_extend_i32_u.
    ls_row-name = 'ZCL_WASM_I64_EXTEND_I32_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_trunc_f32_s.
    ls_row-name = 'ZCL_WASM_I64_TRUNC_F32_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_trunc_f32_u.
    ls_row-name = 'ZCL_WASM_I64_TRUNC_F32_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_trunc_f64_s.
    ls_row-name = 'ZCL_WASM_I64_TRUNC_F64_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_trunc_f64_u.
    ls_row-name = 'ZCL_WASM_I64_TRUNC_F64_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_convert_i32_s.
    ls_row-name = 'ZCL_WASM_F32_CONVERT_I32_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_convert_i32_u.
    ls_row-name = 'ZCL_WASM_F32_CONVERT_I32_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_convert_i64_s.
    ls_row-name = 'ZCL_WASM_F32_CONVERT_I64_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_convert_i64_u.
    ls_row-name = 'ZCL_WASM_F32_CONVERT_I64_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_demote_f64.
    ls_row-name = 'ZCL_WASM_F32_DEMOTE_F64'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_convert_i32_s.
    ls_row-name = 'ZCL_WASM_F64_CONVERT_I32_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_convert_i32_u.
    ls_row-name = 'ZCL_WASM_F64_CONVERT_I32_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_convert_i64_s.
    ls_row-name = 'ZCL_WASM_F64_CONVERT_I64_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_convert_i64_u.
    ls_row-name = 'ZCL_WASM_F64_CONVERT_I64_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_promote_f32.
    ls_row-name = 'ZCL_WASM_F64_PROMOTE_F32'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_load.
    ls_row-name = 'ZCL_WASM_I64_LOAD'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_load.
    ls_row-name = 'ZCL_WASM_F32_LOAD'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_load.
    ls_row-name = 'ZCL_WASM_F64_LOAD'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_load8_s.
    ls_row-name = 'ZCL_WASM_I32_LOAD8_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_load8_u.
    ls_row-name = 'ZCL_WASM_I32_LOAD8_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_add.
    ls_row-name = 'ZCL_WASM_F64_ADD'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_sub.
    ls_row-name = 'ZCL_WASM_F64_SUB'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_mul.
    ls_row-name = 'ZCL_WASM_F64_MUL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_div.
    ls_row-name = 'ZCL_WASM_F64_DIV'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_min.
    ls_row-name = 'ZCL_WASM_F64_MIN'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_max.
    ls_row-name = 'ZCL_WASM_F64_MAX'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f64_copysign.
    ls_row-name = 'ZCL_WASM_F64_COPYSIGN'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_load16_s.
    ls_row-name = 'ZCL_WASM_I32_LOAD16_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_load16_u.
    ls_row-name = 'ZCL_WASM_I32_LOAD16_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_add.
    ls_row-name = 'ZCL_WASM_F32_ADD'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_clz.
    ls_row-name = 'ZCL_WASM_I64_CLZ'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_popcnt.
    ls_row-name = 'ZCL_WASM_I64_POPCNT'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-select_star.
    ls_row-name = 'ZCL_WASM_SELECT_STAR'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_extend8_s.
    ls_row-name = 'ZCL_WASM_I64_EXTEND8_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_extend16_s.
    ls_row-name = 'ZCL_WASM_I64_EXTEND16_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_extend32_s.
    ls_row-name = 'ZCL_WASM_I64_EXTEND32_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_add.
    ls_row-name = 'ZCL_WASM_I64_ADD'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_load8_s.
    ls_row-name = 'ZCL_WASM_I64_LOAD8_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_load8_u.
    ls_row-name = 'ZCL_WASM_I64_LOAD8_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_eqz.
    ls_row-name = 'ZCL_WASM_I64_EQZ'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_load16_s.
    ls_row-name = 'ZCL_WASM_I64_LOAD16_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-table_get.
    ls_row-name = 'ZCL_WASM_TABLE_GET'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-table_set.
    ls_row-name = 'ZCL_WASM_TABLE_SET'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-f32_store.
    ls_row-name = 'ZCL_WASM_F32_STORE'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i32_store16.
    ls_row-name = 'ZCL_WASM_I32_STORE16'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_store8.
    ls_row-name = 'ZCL_WASM_I64_STORE8'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_store32.
    ls_row-name = 'ZCL_WASM_I64_STORE32'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_load16_u.
    ls_row-name = 'ZCL_WASM_I64_LOAD16_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-ref_null.
    ls_row-name = 'ZCL_WASM_REF_NULL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-ref_is_null.
    ls_row-name = 'ZCL_WASM_REF_IS_NULL'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-ref_func.
    ls_row-name = 'ZCL_WASM_REF_FUNC'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_load32_s.
    ls_row-name = 'ZCL_WASM_I64_LOAD32_S'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-i64_load32_u.
    ls_row-name = 'ZCL_WASM_I64_LOAD32_U'.
    INSERT ls_row INTO TABLE gt_opcodes.

    ls_row-opcode = zif_wasm_opcodes=>c_opcodes-drop.
    ls_row-name = 'ZCL_WASM_DROP'.
    INSERT ls_row INTO TABLE gt_opcodes.

    gv_initialized = abap_true.
  ENDMETHOD.


  METHOD parse.

    DATA li_instruction TYPE REF TO zif_wasm_instruction.
    DATA lv_opcode      TYPE x LENGTH 1.

    IF gv_initialized = abap_false.
      initialize( ).
    ENDIF.

    WHILE io_body->get_length( ) > 0.
      lv_opcode = io_body->shift( 1 ).
      ev_last_opcode = lv_opcode.

      READ TABLE gt_opcodes ASSIGNING FIELD-SYMBOL(<ls_opcode>) WITH TABLE KEY opcode = lv_opcode.
      IF sy-subrc = 0.
        CALL METHOD (<ls_opcode>-name)=>parse
          EXPORTING
            io_body        = io_body
          RECEIVING
            ri_instruction = li_instruction.
        APPEND li_instruction TO et_instructions.
      ELSE.
        CASE lv_opcode.
          WHEN 'FC'.
            DATA(lv_opcodei) = io_body->shift_u32( ).
            CASE lv_opcodei.
              WHEN zif_wasm_opcodes=>c_opcodes-i32_trunc_sat_f32_s.
                APPEND zcl_wasm_i32_trunc_sat_f32_s=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-i32_trunc_sat_f32_u.
                APPEND zcl_wasm_i32_trunc_sat_f32_u=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-i32_trunc_sat_f64_s.
                APPEND zcl_wasm_i32_trunc_sat_f64_s=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-i32_trunc_sat_f64_u.
                APPEND zcl_wasm_i32_trunc_sat_f64_u=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-i64_trunc_sat_f32_s.
                APPEND zcl_wasm_i64_trunc_sat_f32_s=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-i64_trunc_sat_f32_u.
                APPEND zcl_wasm_i64_trunc_sat_f32_u=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-i64_trunc_sat_f64_s.
                APPEND zcl_wasm_i64_trunc_sat_f64_s=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-i64_trunc_sat_f64_u.
                APPEND zcl_wasm_i64_trunc_sat_f64_u=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-memory_init.
                APPEND zcl_wasm_memory_init=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-data_drop.
                APPEND zcl_wasm_data_drop=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-memory_copy.
                APPEND zcl_wasm_memory_copy=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-memory_fill.
                APPEND zcl_wasm_memory_fill=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-table_init.
                APPEND zcl_wasm_table_init=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-elem_drop.
                APPEND zcl_wasm_elem_drop=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-table_copy.
                APPEND zcl_wasm_table_copy=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-table_grow.
                APPEND zcl_wasm_table_grow=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-table_size.
                APPEND zcl_wasm_table_size=>parse( io_body ) TO et_instructions.
              WHEN zif_wasm_opcodes=>c_opcodes-table_fill.
                APPEND zcl_wasm_table_fill=>parse( io_body ) TO et_instructions.
              WHEN OTHERS.
                RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = |illegal opcode FC: { lv_opcodei }|.
            ENDCASE.
          WHEN zif_wasm_opcodes=>c_opcodes-end.
            APPEND zcl_wasm_end=>parse( io_body ) TO et_instructions.
            RETURN.
          WHEN zif_wasm_opcodes=>c_opcodes-else_.
            RETURN.
          WHEN OTHERS.
            RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = |illegal opcode: { lv_opcode }|.
        ENDCASE.
      ENDIF.
    ENDWHILE.

  ENDMETHOD.
ENDCLASS.
