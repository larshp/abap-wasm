CLASS zcl_wasm_memory_frame DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_memory_frame.
  PRIVATE SECTION.
    TYPES ty_locals TYPE STANDARD TABLE OF REF TO zif_wasm_value WITH DEFAULT KEY.
    DATA mt_locals TYPE ty_locals.
ENDCLASS.

CLASS zcl_wasm_memory_frame IMPLEMENTATION.

  METHOD zif_wasm_memory_frame~local_get.
* the caller must translate the index to ABAP index
    READ TABLE mt_locals INDEX iv_index INTO ri_value.
    "##feature-start=debug
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = 'zcl_wasm_memory_frame: not found in local memory, local_get'.
    ENDIF.
    "##feature-end=debug
  ENDMETHOD.


  METHOD zif_wasm_memory_frame~local_push_first.

    INSERT ii_value INTO mt_locals INDEX 1.

  ENDMETHOD.

  METHOD zif_wasm_memory_frame~local_push_last.

    INSERT ii_value INTO TABLE mt_locals.

  ENDMETHOD.


  METHOD zif_wasm_memory_frame~local_set.
* the caller must translate the index to ABAP index
    MODIFY mt_locals INDEX iv_index FROM ii_value.
    "##feature-start=debug
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = 'zcl_wasm_memory_frame: not found in local memory, local_set'.
    ENDIF.
    "##feature-end=debug
  ENDMETHOD.

ENDCLASS.
