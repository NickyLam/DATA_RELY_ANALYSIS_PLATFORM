: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_party_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_pty_party.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.src_party_id as src_party_id
,t1.party_name as party_name
,t1.party_type_cd as party_type_cd
,t1.effect_dt as effect_dt
,t1.invalid_dt as invalid_dt
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.src_party_type_cd as src_party_type_cd
,t1.party_id as party_id
,t1.lp_id as lp_id
,t1.job_cd as job_cd

from ${idl_schema}.oass_pty_party t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_party.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
