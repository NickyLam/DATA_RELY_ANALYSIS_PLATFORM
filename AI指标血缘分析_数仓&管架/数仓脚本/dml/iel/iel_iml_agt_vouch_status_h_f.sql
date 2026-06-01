: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_vouch_status_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_vouch_status_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.vouch_status_type_cd,chr(13),''),chr(10),'') as vouch_status_type_cd
,replace(replace(t1.vouch_status_cd,chr(13),''),chr(10),'') as vouch_status_cd

from ${iml_schema}.agt_vouch_status_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_vouch_status_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
