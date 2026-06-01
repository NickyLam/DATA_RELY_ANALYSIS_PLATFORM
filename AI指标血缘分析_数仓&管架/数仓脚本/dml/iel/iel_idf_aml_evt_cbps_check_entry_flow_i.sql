: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_evt_cbps_check_entry_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_cbps_check_entry_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,evt_id
,lp_id
,sys_id
,midgrod_flow_num
,midgrod_tran_dt
,midgrod_tran_tm
,msg_type_id
,core_tran_code
,midgrod_tran_code
,mgmt_org_id
,tran_org_id
,teller_id
,tran_type_cd
,tran_status_cd
,core_tran_dt
,core_tran_flow_num
,payer_acct_num
,payer_name
,recver_acct_num
,recver_name
,pay_flow_num
,init_pay_flow_num
,return_cd
,return_info_desc
,tran_amt
,entry_code
,check_entry_dt
,check_entry_status_cd
from idl.aml_evt_cbps_check_entry_flow
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_cbps_check_entry_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes