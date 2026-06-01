: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_payoff_withhold_batch_dtl_a
CreateDate: 20230705
FileName:   ${iel_data_path}/evt_payoff_withhold_batch_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,tran_dt
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.deduct_seq_num,chr(13),''),chr(10),'') as deduct_seq_num
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,amt
,replace(replace(t1.acct_num_resp_code,chr(13),''),chr(10),'') as acct_num_resp_code
,replace(replace(t1.acct_num_resp_info,chr(13),''),chr(10),'') as acct_num_resp_info
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,host_tran_dt
,replace(replace(t1.host_return_code,chr(13),''),chr(10),'') as host_return_code
,replace(replace(t1.host_return_info,chr(13),''),chr(10),'') as host_return_info

from ${iml_schema}.evt_payoff_withhold_batch_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_payoff_withhold_batch_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
