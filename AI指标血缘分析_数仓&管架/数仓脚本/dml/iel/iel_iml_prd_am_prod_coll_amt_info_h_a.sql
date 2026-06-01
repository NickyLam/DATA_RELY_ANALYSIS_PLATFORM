: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_am_prod_coll_amt_info_h_a
CreateDate: 20250928
FileName:   ${iel_data_path}/prd_am_prod_coll_amt_info_h.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id
,calc_start_dt
,begin_dt
,coll_amt
,td_coll_amt
,replace(replace(t1.prft_type_cd,chr(13),''),chr(10),'') as prft_type_cd
,replace(replace(t1.creator_name,chr(13),''),chr(10),'') as creator_name
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,init_create_dt
,replace(replace(t1.updater_name,chr(13),''),chr(10),'') as updater_name
,latest_update_dt

from ${iml_schema}.prd_am_prod_coll_amt_info_h t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_am_prod_coll_amt_info_h.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
