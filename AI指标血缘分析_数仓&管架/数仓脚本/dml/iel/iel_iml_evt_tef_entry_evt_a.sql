: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_tef_entry_evt_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_tef_entry_evt.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num 
,t1.tran_dt as tran_dt 
,replace(replace(t1.sys_cd,chr(13),''),chr(10),'') as sys_cd 
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm 
,replace(replace(t1.front_flow_num,chr(13),''),chr(10),'') as front_flow_num 
,t1.front_dt as front_dt 
,replace(replace(t1.host_tran_code,chr(13),''),chr(10),'') as host_tran_code 
,replace(replace(t1.midgrod_tran_code,chr(13),''),chr(10),'') as midgrod_tran_code 
,replace(replace(t1.proc_org_id,chr(13),''),chr(10),'') as proc_org_id 
,replace(replace(t1.proc_teller_id,chr(13),''),chr(10),'') as proc_teller_id 
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd 
,t1.host_dt as host_dt 
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num 
,replace(replace(t1.pay_acct,chr(13),''),chr(10),'') as pay_acct 
,replace(replace(t1.pay_acct_name,chr(13),''),chr(10),'') as pay_acct_name 
,replace(replace(t1.recvbl_acct,chr(13),''),chr(10),'') as recvbl_acct 
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name 
,replace(replace(t1.tran_index_num,chr(13),''),chr(10),'') as tran_index_num 
,replace(replace(t1.err_return_code,chr(13),''),chr(10),'') as err_return_code 
,replace(replace(t1.err_info,chr(13),''),chr(10),'') as err_info 
,replace(replace(t1.check_entry_status_cd,chr(13),''),chr(10),'') as check_entry_status_cd 
,t1.tran_amt as tran_amt 
,replace(replace(t1.acct_ety_code,chr(13),''),chr(10),'') as acct_ety_code 
,t1.check_entry_dt as check_entry_dt 
,replace(replace(t1.e_acct_cd,chr(13),''),chr(10),'') as e_acct_cd 
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num 
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num 
from ${iml_schema}.evt_tef_entry_evt t1 
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date(substr('${batch_date}',1,6)||'01','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_tef_entry_evt.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes