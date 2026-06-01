: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_party_name_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_pty_party_name_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.src_sys_cd as src_sys_cd
,t1.party_name_type_cd as party_name_type_cd
,t1.party_name as party_name
,t1.party_abbr as party_abbr
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_party_name_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_party_name_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
