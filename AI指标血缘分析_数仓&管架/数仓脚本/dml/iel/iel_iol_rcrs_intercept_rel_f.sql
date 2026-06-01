: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_intercept_rel_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_intercept_rel.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.prj_id,chr(13),''),chr(10),'') as prj_id
,replace(replace(t.prj_name,chr(13),''),chr(10),'') as prj_name
,replace(replace(t.item_id,chr(13),''),chr(10),'') as item_id
,replace(replace(t.item_name,chr(13),''),chr(10),'') as item_name
,t.priority as priority
,replace(replace(t.is_intercept_business,chr(13),''),chr(10),'') as is_intercept_business
,replace(replace(t.collect_type,chr(13),''),chr(10),'') as collect_type
,replace(replace(t.ja_code_type,chr(13),''),chr(10),'') as ja_code_type
,replace(replace(t.zzc_code_type,chr(13),''),chr(10),'') as zzc_code_type
,replace(replace(t.bj_code_type,chr(13),''),chr(10),'') as bj_code_type
,replace(replace(t.bh_code_type,chr(13),''),chr(10),'') as bh_code_type
from iol.rcrs_intercept_rel t
where t.etl_dt=to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_intercept_rel.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes