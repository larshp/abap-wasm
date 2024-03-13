CLASS zcl_wasm_memory_linear DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_wasm_memory_linear.

    METHODS constructor
      IMPORTING
        iv_max TYPE int8
        iv_min TYPE int8
      RAISING
        zcx_wasm.
  PRIVATE SECTION.
    TYPES ty_page TYPE x LENGTH zif_wasm_memory_linear=>c_page_size.

    DATA mt_pages TYPE STANDARD TABLE OF ty_page WITH DEFAULT KEY.
    DATA mv_max TYPE int8.
    DATA mv_min TYPE int8.
ENDCLASS.

CLASS zcl_wasm_memory_linear IMPLEMENTATION.

  METHOD constructor.
    mv_min = iv_min.
    mv_max = iv_max.

    zif_wasm_memory_linear~grow( mv_min ).
  ENDMETHOD.

  METHOD zif_wasm_memory_linear~grow.
    IF iv_pages < 0.
      RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = 'zcl_wasm_memory: linear_grow, negative pages'.
    ELSEIF zif_wasm_memory_linear~size_in_pages( ) + iv_pages >= zif_wasm_memory_linear=>c_max_pages.
      RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = 'zcl_wasm_memory: linear_grow, max pages reached'.
    ELSEIF iv_pages >= 1000.
      RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = 'zcl_wasm_memory: todo, its too slow, and will crash node anyhow'.
    ENDIF.

    DO iv_pages TIMES.
      INSERT INITIAL LINE INTO TABLE mt_pages.
    ENDDO.
  ENDMETHOD.

  METHOD zif_wasm_memory_linear~size_in_pages.
    rv_pages = lines( mt_pages ).
  ENDMETHOD.

  METHOD zif_wasm_memory_linear~size_in_bytes.
    rv_bytes = lines( mt_pages ) * zif_wasm_memory_linear=>c_page_size.
  ENDMETHOD.

  METHOD zif_wasm_memory_linear~set.
    WRITE: / 'set original offset:', iv_offset.

    DATA(lv_page) = iv_offset DIV zif_wasm_memory_linear=>c_page_size.
    lv_page = lv_page + 1.
    WRITE: / 'set page:', lv_page.
    READ TABLE mt_pages INDEX lv_page ASSIGNING FIELD-SYMBOL(<lv_page>).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = 'linear_set: out of bounds'.
    ENDIF.

    DATA(lv_offset) = iv_offset MOD zif_wasm_memory_linear=>c_page_size.
    WRITE: / 'set offset:', lv_offset.
    DATA(lv_length) = xstrlen( iv_bytes ).
    WRITE: / 'set length:', lv_length.
* todo: some extra checking here? plus setting values across multiple tables?
    <lv_page>+lv_offset(lv_length) = iv_bytes.
    WRITE / <lv_page>(50).

"     DATA(lv_length) = xstrlen( iv_bytes ).
"     IF iv_offset = 0.
"       CONCATENATE iv_bytes mv_linear+lv_length INTO mv_linear IN BYTE MODE.
"     ELSE.
"       IF mv_linear+iv_offset(lv_length) = iv_bytes.
" * optimization for scrypt?
"         RETURN.
"       ENDIF.
"       lv_length = lv_length + iv_offset.
"       CONCATENATE mv_linear(iv_offset) iv_bytes mv_linear+lv_length INTO mv_linear IN BYTE MODE.
"     ENDIF.
  ENDMETHOD.

  METHOD zif_wasm_memory_linear~get.
* https://rsms.me/wasm-intro#addressing-memory

    DATA lv_byte TYPE x LENGTH 1.

    " DATA(lv_length) = xstrlen( mv_linear ).
    " IF iv_offset + iv_length > lv_length.
    "   RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = 'linear_get: out of bounds'.
    " ELSEIF iv_length <= 0.
    "   RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = 'linear_get: negative or zero length'.
    " ELSEIF iv_offset < 0.
    "   RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = 'linear_get: negative offset'.
    " ENDIF.

    WRITE: / 'get original offset:', iv_offset.
    DATA(lv_page) = iv_offset DIV zif_wasm_memory_linear=>c_page_size.
    lv_page = lv_page + 1.
    WRITE: / 'get page:', lv_page.
    READ TABLE mt_pages INDEX lv_page ASSIGNING FIELD-SYMBOL(<lv_page>).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_wasm EXPORTING text = 'linear_get: out of bounds'.
    ENDIF.

    DATA(lv_offset) = iv_offset MOD zif_wasm_memory_linear=>c_page_size.
    WRITE: / 'get offset:', lv_offset.
    WRITE: / 'get length:', iv_length.
    WRITE / <lv_page>(50).

* return multiple bytes in endian order
    DO iv_length TIMES.
      lv_byte = <lv_page>+lv_offset(1).
      CONCATENATE lv_byte rv_bytes INTO rv_bytes IN BYTE MODE.
      lv_offset = lv_offset + 1.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
