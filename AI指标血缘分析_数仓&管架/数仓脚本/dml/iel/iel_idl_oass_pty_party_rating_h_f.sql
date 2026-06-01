: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_party_rating_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_pty_party_rating_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.sorc_sys_cd as sorc_sys_cd
,t1.party_rating_type_cd as party_rating_type_cd
,t1.seq_num as seq_num
,t1.rating_org_id as rating_org_id
,t1.rating_org_name as rating_org_name
,t1.rating_dt as rating_dt
,t1.rating_score_val as rating_score_val
,t1.rating_effect_dt as rating_effect_dt
,t1.rating_invalid_dt as rating_invalid_dt
,t1.rating_result_cd as rating_result_cd
,t1.irs_task_flow_num as irs_task_flow_num
,t1.rating_level_cd as rating_level_cd
,t1.lmt as lmt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_party_rating_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_party_rating_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
