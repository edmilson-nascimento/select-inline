report inline .

SELECT 'I' AS sign,
       'EQ' AS option,
       bp~node_key AS low,
       bp~node_key AS high

  FROM snwd_bpa AS bp
 INNER JOIN snwd_ad AS ad
    ON bp~address_guid EQ ad~node_key

  INTO TABLE @DATA(range_parceiros) .
IF ( sy-subrc EQ 0 ) .
ENDIF .


SELECT bp~node_key, company_name,

  CASE bp_role
    WHEN '01' THEN 'Customer'
    WHEN '02' THEN 'Supplier'
  END AS tipo,

       street && ' ' && building AS street,

       7 * 8 AS three,

       @sy-datum AS today

  FROM snwd_bpa AS bp
    INNER JOIN snwd_ad AS ad
    ON bp~address_guid EQ ad~node_key

  INTO TABLE @DATA(t_parceiros)

  WHERE bp~node_key IN @range_parceiros.

IF sy-subrc EQ 0 .

  CALL METHOD cl_salv_table=>factory
    IMPORTING
      r_salv_table = DATA(r_alv)
    CHANGING
      t_table      = t_parceiros.

  r_alv->set_screen_status(
  EXPORTING
    report        = 'SAPLKKBL'
    pfstatus      = 'STANDARD_FULLSCREEN'
    set_functions =  r_alv->c_functions_all ) .

  r_alv->display( ).

ENDIF .

*CONSTANTS:
*  BEGIN OF gs_settings,
*    object    TYPE bal_s_log-object    VALUE 'ZTEMP',
*    subobject TYPE bal_s_log-subobject VALUE 'TEMP',
*  END OF gs_settings .
*
*DATA:
*  gv_extnumber TYPE guid_32 .
*
*" Buscando uma chave para exemplo
*CALL FUNCTION 'GUID_CREATE'
*  IMPORTING
*    ev_guid_32 = gv_extnumber.
*
*gv_extnumber = '064076AA66D31EEEADA91F64E7DB044F' .
*
*MESSAGE s000(/yga/jump) WITH 'Mensagem da Alexandra: '
*                             gv_extnumber INTO DATA(message).
*
*DATA(go_object) = NEW zca_cl_util_log(
*  i_object    = gs_settings-object
*  i_subobject = gs_settings-subobject
*  i_extnumber = CONV bal_s_log-extnumber( gv_extnumber ) ) .
*
*IF ( go_object IS NOT BOUND ) .
*  RETURN .
*ENDIF .
*
*go_object->add_message( save = abap_true ) .


***TYPES:
***  BEGIN OF ts_knbk,
***    kunnr TYPE knbk-kunnr,
***    koinh TYPE knbk-koinh,
***  END OF ts_knbk,
***  knbk_t TYPE STANDARD TABLE OF ts_knbk
***           WITH DEFAULT KEY .
***
***DATA(lt_knbk1) = VALUE knbk_t(
*** ( kunnr = '111'
***   koinh = 'Name 111' )
*** ( kunnr = '123'
***   koinh = 'Name 123' )
***).
***
***DATA(lt_knbk2) = VALUE knbk_t(
*** ( kunnr = '123'
***   koinh = 'Name 123' )
*** ( kunnr = '122'
***   koinh = 'Name 122' )
*** ( kunnr = '121'
***   koinh = 'Name 121' )
***).
***
****types tt_xknbk type sorted table of ts_knbk ...
****types tt_yknbk type sorted table of ts_knbk ...
***
***
***DATA(lt_knbk_diff) = VALUE knbk_t(
***  FOR ls_knbk IN COND #( WHEN lines( lt_knbk1 ) >= lines( lt_knbk2 ) THEN lt_knbk1 ELSE lt_knbk2 )
***    ( LINES OF COND #(
***      WHEN lines( lt_knbk1 ) >= lines( lt_knbk2 ) AND NOT line_exists( lt_knbk2[ table_line = ls_knbk ] ) THEN VALUE #( ( ls_knbk ) )
***      WHEN lines( lt_knbk2 ) > lines( lt_knbk1 ) AND NOT line_exists( lt_knbk1[ table_line = ls_knbk ] ) THEN VALUE #( ( ls_knbk ) )
***    ) )
***).
***
***
***BREAK-POINT .
***
***DATA:
***  uv_quantity TYPE menge_d,
***  cv_quantity TYPE char10.
***
***cv_quantity = condense( |{ uv_quantity }| ) .
***cv_quantity = CONV #( |{ uv_quantity }| ) .
***
***
***BREAK-POINT .

