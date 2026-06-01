: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_pty_party_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_pty_party.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,party_id
,lp_id
,src_party_id
,party_name
,party_type_cd
,effect_dt
,invalid_dt from idl.icrm_pty_party where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_pty_party.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes