: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_org_int_org_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/org_int_org_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,replace(replace(t1.org_rela_type_cd,chr(13),''),chr(10),'') as org_rela_type_cd
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,t1.start_dt as start_dt
,replace(replace(t1.rela_org_id,chr(13),''),chr(10),'') as rela_org_id
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.org_int_org_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/org_int_org_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes