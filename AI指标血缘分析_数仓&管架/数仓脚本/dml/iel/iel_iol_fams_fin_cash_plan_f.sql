: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_cash_plan_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_fin_cash_plan.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(cash_id,chr(13),''),chr(10),'') as cash_id
      ,cash_num
      ,replace(replace(cash_type,chr(13),''),chr(10),'') as cash_type
      ,vdate_unadjust
      ,mdate_unadjust
      ,pay_date_unadjust
      ,vdate
      ,mdate
      ,pay_date
      ,termdays
      ,vdate_y
      ,vdate_term
      ,mdate_term
      ,termdays_term
      ,prin_amt
      ,int_prin_amt
      ,int_amt
      ,replace(replace(is_pay_int,chr(13),''),chr(10),'') as is_pay_int
      ,cash_amt
      ,cash_baseamt
      ,replace(replace(cash_unit_type,chr(13),''),chr(10),'') as cash_unit_type
      ,replace(replace(calc_function,chr(13),''),chr(10),'') as calc_function
      ,frequency
      ,replace(replace(finprod_id,chr(13),''),chr(10),'') as finprod_id
      ,replace(replace(finprod_type,chr(13),''),chr(10),'') as finprod_type
      ,replace(replace(finprod_type2,chr(13),''),chr(10),'') as finprod_type2
      ,branch
      ,replace(replace(pay_type,chr(13),''),chr(10),'') as pay_type
      ,range_yield
      ,replace(replace(remark,chr(13),''),chr(10),'') as remark
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,repay_without_int
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_fin_cash_plan
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_cash_plan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes