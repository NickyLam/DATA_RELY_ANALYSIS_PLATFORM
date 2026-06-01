: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_fee_rat_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_fee_rat_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.init_prod_id,chr(13),''),chr(10),'') as init_prod_id
,replace(replace(t1.fee_rat_type_cd,chr(13),''),chr(10),'') as fee_rat_type_cd
,t1.prod_fee_rat as prod_fee_rat
,t1.effect_dt as effect_dt
,t1.invalid_dt as invalid_dt
,t1.fee_rat_update_dt as fee_rat_update_dt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.prd_fee_rat_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_fee_rat_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes