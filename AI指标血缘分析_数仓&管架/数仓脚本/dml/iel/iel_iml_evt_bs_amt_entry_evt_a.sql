: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bs_amt_entry_evt_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_bs_amt_entry_evt.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.bs_amt_entry_id,chr(13),''),chr(10),'') as bs_amt_entry_id 
,replace(replace(t1.sys_cd,chr(13),''),chr(10),'') as sys_cd 
,t1.tran_dt as tran_dt 
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm 
,replace(replace(t1.bank_int_bus_seq_num,chr(13),''),chr(10),'') as bank_int_bus_seq_num 
,replace(replace(t1.bus_seq_num,chr(13),''),chr(10),'') as bus_seq_num 
,replace(replace(t1.msg_type_id,chr(13),''),chr(10),'') as msg_type_id 
,replace(replace(t1.host_tran_code,chr(13),''),chr(10),'') as host_tran_code 
,replace(replace(t1.midgrod_tran_code,chr(13),''),chr(10),'') as midgrod_tran_code 
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id 
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id 
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd 
,t1.host_dt as host_dt 
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num 
,replace(replace(t1.payer_acct_num,chr(13),''),chr(10),'') as payer_acct_num 
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name 
,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num 
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name 
,replace(replace(t1.trdpty_idf_id,chr(13),''),chr(10),'') as trdpty_idf_id 
,replace(replace(t1.err_return_code,chr(13),''),chr(10),'') as err_return_code 
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info 
,replace(replace(t1.check_entry_status_cd,chr(13),''),chr(10),'') as check_entry_status_cd 
,t1.tran_amt as tran_amt 
,replace(replace(t1.entry_code,chr(13),''),chr(10),'') as entry_code 
,t1.check_entry_dt as check_entry_dt 
,replace(replace(t1.e_acct_cd,chr(13),''),chr(10),'') as e_acct_cd 
,replace(replace(t1.req_flow_num,chr(13),''),chr(10),'') as req_flow_num 
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num 
from ${iml_schema}.evt_bs_amt_entry_evt t1 
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date(substr('${batch_date}',1,6)||'01','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bs_amt_entry_evt.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes