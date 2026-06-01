: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_teller_post_rela_info_f
CreateDate: 20230602
FileName:   ${iel_data_path}/pty_teller_post_rela_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.post_id,chr(13),''),chr(10),'') as post_id
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id

from ${iml_schema}.pty_teller_post_rela_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_teller_post_rela_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
