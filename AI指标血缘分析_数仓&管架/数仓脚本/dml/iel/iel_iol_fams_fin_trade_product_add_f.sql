: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_trade_product_add_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_fin_trade_product_add.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(finprod_id,chr(13),''),chr(10),'') as finprod_id
      ,replace(replace(finprod_type,chr(13),''),chr(10),'') as finprod_type
      ,replace(replace(finprod_type2,chr(13),''),chr(10),'') as finprod_type2
      ,branch
      ,replace(replace(regist_org,chr(13),''),chr(10),'') as regist_org
      ,pledge_sec_num
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,replace(replace(exchange_pledge,chr(13),''),chr(10),'') as exchange_pledge
      ,replace(replace(supply_clause,chr(13),''),chr(10),'') as supply_clause
      ,replace(replace(is_accr_penalty_int,chr(13),''),chr(10),'') as is_accr_penalty_int
      ,replace(replace(penalty_base_type,chr(13),''),chr(10),'') as penalty_base_type
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_fin_trade_product_add
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_trade_product_add.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes