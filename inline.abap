report inline .

select bp~node_key, company_name,

  case bp_role
    when '01' then 'Customer'
    when '02' then 'Supplier'
  end as tipo,

       street && ' ' && building as street,
       
       7 * 8 as three,
       
       @sy-datum as today

  from snwd_bpa as bp
    inner join snwd_ad as ad
    on bp~address_guid eq ad~node_key

  into table @data(t_parceiros) .

if sy-subrc eq 0 .

  call method cl_salv_table=>factory
*   exporting
*     list_display   = if_salv_c_bool_sap=>false
*     r_container    =
*     container_name =
    importing
      r_salv_table = data(r_alv)
    changing
      t_table      = t_parceiros.

  r_alv->set_screen_status(
  exporting
    report        = 'SAPLKKBL'
    pfstatus      = 'STANDARD_FULLSCREEN'
    set_functions =  r_alv->c_functions_all
    ).

  r_alv->display( ).


endif .
