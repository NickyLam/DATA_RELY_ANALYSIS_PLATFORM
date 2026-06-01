: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_payoff_sal_dtl_i
CreateDate: 20221111
FileName:   ${iel_data_path}/evt_payoff_sal_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,tran_dt
,replace(replace(t1.batch_flow_num,chr(13),''),chr(10),'') as batch_flow_num
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,tran_amt
,replace(replace(t1.acct_resp_code,chr(13),''),chr(10),'') as acct_resp_code
,replace(replace(t1.acct_num_err_info,chr(13),''),chr(10),'') as acct_num_err_info
,replace(replace(t1.host_tran_flow_num,chr(13),''),chr(10),'') as host_tran_flow_num
,host_tran_dt
,replace(replace(t1.resp_code,chr(13),''),chr(10),'') as resp_code
,replace(replace(t1.resp_info,chr(13),''),chr(10),'') as resp_info

from ${iml_schema}.evt_payoff_sal_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_payoff_sal_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
