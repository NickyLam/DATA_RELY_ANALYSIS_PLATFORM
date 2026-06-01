: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_lp_info_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_lp_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,replace(replace(t1.multi_lp_allow_acrs_lp_que_flg,chr(13),''),chr(10),'') as multi_lp_allow_acrs_lp_que_flg
,replace(replace(t1.general_exch_lp_id,chr(13),''),chr(10),'') as general_exch_lp_id
,replace(replace(t1.general_storage_lp_id,chr(13),''),chr(10),'') as general_storage_lp_id

from ${iml_schema}.ref_lp_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_lp_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
