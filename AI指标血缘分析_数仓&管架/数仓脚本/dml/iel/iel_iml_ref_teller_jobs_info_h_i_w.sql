: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_teller_jobs_info_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_teller_jobs_info_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.jobs_id,chr(13),''),chr(10),'') as jobs_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.jobs_name,chr(13),''),chr(10),'') as jobs_name
,replace(replace(t.cors_moy_box_id,chr(13),''),chr(10),'') as cors_moy_box_id
,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t.on_guard_teller_id,chr(13),''),chr(10),'') as on_guard_teller_id
,replace(replace(t.jobs_cate_cd,chr(13),''),chr(10),'') as jobs_cate_cd
,replace(replace(t.guard_teller_id,chr(13),''),chr(10),'') as guard_teller_id
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_teller_jobs_info_h t 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_teller_jobs_info_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes