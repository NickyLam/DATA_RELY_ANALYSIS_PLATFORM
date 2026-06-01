: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_cash_info_f
CreateDate: 20240702
FileName:   ${iel_data_path}/fams_fin_cash_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cash_id,chr(13),''),chr(10),'') as cash_id
,replace(replace(t1.cash_type_1,chr(13),''),chr(10),'') as cash_type_1
,replace(replace(t1.cash_type_2,chr(13),''),chr(10),'') as cash_type_2
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,replace(replace(t1.finprod_type,chr(13),''),chr(10),'') as finprod_type
,branch
,replace(replace(t1.fee_id,chr(13),''),chr(10),'') as fee_id
,replace(replace(t1.chl_finprod_id,chr(13),''),chr(10),'') as chl_finprod_id
,chl_level
,replace(replace(t1.is_calc,chr(13),''),chr(10),'') as is_calc
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,replace(replace(t1.collect_type,chr(13),''),chr(10),'') as collect_type

from ${iol_schema}.fams_fin_cash_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_cash_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
