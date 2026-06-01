: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_payoff_withhold_batch_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_payoff_withhold_batch_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,t.tran_dt as tran_dt
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.batch_id,chr(13),''),chr(10),'') as batch_id
    ,replace(replace(t.deduct_seq_num,chr(13),''),chr(10),'') as deduct_seq_num
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,t.amt as amt
    ,replace(replace(t.acct_num_resp_code,chr(13),''),chr(10),'') as acct_num_resp_code
    ,replace(replace(t.acct_num_resp_info,chr(13),''),chr(10),'') as acct_num_resp_info
    ,replace(replace(t.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
    ,t.host_tran_dt as host_tran_dt
    ,replace(replace(t.host_return_code,chr(13),''),chr(10),'') as host_return_code
    ,replace(replace(t.host_return_info,chr(13),''),chr(10),'') as host_return_info
from iml.evt_payoff_withhold_batch_dtl t
  where t.tran_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_payoff_withhold_batch_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes