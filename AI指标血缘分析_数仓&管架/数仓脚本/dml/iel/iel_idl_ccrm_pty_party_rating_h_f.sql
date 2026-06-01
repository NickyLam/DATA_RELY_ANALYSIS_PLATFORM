: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_pty_party_rating_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_pty_party_rating_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,party_id
,lp_id
,sorc_sys_cd
,party_rating_type_cd
,seq_num
,start_dt
,rating_org_id
,rating_org_name
,rating_dt
,rating_score_val
,rating_effect_dt
,rating_invalid_dt
,rating_result_cd
,irs_task_flow_num
,rating_level_cd
,lmt
,end_dt
,id_mark
from idl.ccrm_pty_party_rating_h
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_pty_party_rating_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes