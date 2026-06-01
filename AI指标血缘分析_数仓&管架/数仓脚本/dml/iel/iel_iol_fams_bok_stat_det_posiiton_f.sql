: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_stat_det_posiiton_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_bok_stat_det_posiiton.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(bookset_id,chr(13),''),chr(10),'') as bookset_id
      ,happen_date
      ,book_date
      ,replace(replace(bok_detail_id,chr(13),''),chr(10),'') as bok_detail_id
      ,book_summary_order
      ,bookset_date
      ,pos_amt
      ,int_rate
      ,dailydsc_yield
      ,tdy_intincexp_add
      ,tdy_intincexp
      ,replace(replace(finprod_type,chr(13),''),chr(10),'') as finprod_type
      ,vdate
      ,mdate
      ,replace(replace(chl_id,chr(13),''),chr(10),'') as chl_id
      ,replace(replace(inv_aim,chr(13),''),chr(10),'') as inv_aim
      ,tdy_position
      ,tdy_cost_amt
      ,tdy_float_ingpl
      ,end_days_1
      ,end_days_2
      ,end_days_cost_amt
      ,replace(replace(busi_id,chr(13),''),chr(10),'') as busi_id
      ,val_date
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,tdy_float_ingpl_exp
      ,replace(replace(ccy,chr(13),''),chr(10),'') as ccy
      ,replace(replace(b_ccy,chr(13),''),chr(10),'') as b_ccy
      ,tdy_intincexp_add_b
      ,tdy_cost_amt_b
      ,tdy_float_ingpl_b
      ,tdy_float_ingpl_exp_b
      ,tdy_intincexp_b
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_bok_stat_det_posiiton
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_stat_det_posiiton.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes