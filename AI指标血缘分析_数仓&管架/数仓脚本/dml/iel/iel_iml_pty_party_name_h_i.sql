: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_name_h_i
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_party_name_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(party_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(src_sys_cd,chr(13),''),chr(10),'')
,replace(replace(party_name_type_cd,chr(13),''),chr(10),'')
,start_dt
,replace(replace(party_name,chr(13),''),chr(10),'')
,replace(replace(party_abbr,chr(13),''),chr(10),'')
,end_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')

from ${iml_schema}.pty_party_name_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_name_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
