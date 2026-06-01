: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agent_sala_sum_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agent_sala_sum_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.agent_acct_cnt as agent_acct_cnt
,t1.agent_total_amt as agent_total_amt
,replace(replace(t1.agent_chn,chr(13),''),chr(10),'') as agent_chn
,replace(replace(t1.agent_mon,chr(13),''),chr(10),'') as agent_mon
,replace(replace(t1.agent_org,chr(13),''),chr(10),'') as agent_org
from ${idl_schema}.hdws_dul_d_ccrm_agent_sala_sum_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agent_sala_sum_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes