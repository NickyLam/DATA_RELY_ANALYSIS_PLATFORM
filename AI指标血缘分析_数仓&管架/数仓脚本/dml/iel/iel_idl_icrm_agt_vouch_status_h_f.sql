: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_agt_vouch_status_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_agt_vouch_status_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,vouch_id
,lp_id
,vouch_status_type_cd
,vouch_status_cd from idl.icrm_agt_vouch_status_h where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_agt_vouch_status_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes