: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bs_amt_entry_evt_i
CreateDate: 20221020
FileName:   ${iel_data_path}/evt_bs_amt_entry_evt.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.bs_amt_entry_id,chr(13),''),chr(10),'') as bs_amt_entry_id
    ,replace(replace(t.sys_cd,chr(13),''),chr(10),'') as sys_cd
    ,t.tran_dt as tran_dt
    ,replace(replace(t.tran_tm,chr(13),''),chr(10),'') as tran_tm
    ,replace(replace(t.bank_int_bus_seq_num,chr(13),''),chr(10),'') as bank_int_bus_seq_num
    ,replace(replace(t.bus_seq_num,chr(13),''),chr(10),'') as bus_seq_num
    ,replace(replace(t.msg_type_id,chr(13),''),chr(10),'') as msg_type_id
    ,replace(replace(t.host_tran_code,chr(13),''),chr(10),'') as host_tran_code
    ,replace(replace(t.midgrod_tran_code,chr(13),''),chr(10),'') as midgrod_tran_code
    ,replace(replace(t.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
    ,replace(replace(t.teller_id,chr(13),''),chr(10),'') as teller_id
    ,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
    ,t.host_dt as host_dt
    ,replace(replace(t.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
    ,replace(replace(t.payer_acct_num,chr(13),''),chr(10),'') as payer_acct_num
    ,replace(replace(t.payer_name,chr(13),''),chr(10),'') as payer_name
    ,replace(replace(t.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
    ,replace(replace(t.recver_name,chr(13),''),chr(10),'') as recver_name
    ,replace(replace(t.trdpty_idf_id,chr(13),''),chr(10),'') as trdpty_idf_id
    ,replace(replace(t.err_return_code,chr(13),''),chr(10),'') as err_return_code
    ,replace(replace(t.return_info,chr(13),''),chr(10),'') as return_info
    ,replace(replace(t.check_entry_status_cd,chr(13),''),chr(10),'') as check_entry_status_cd
    ,t.tran_amt as tran_amt
    ,replace(replace(t.entry_code,chr(13),''),chr(10),'') as entry_code
    ,t.check_entry_dt as check_entry_dt
    ,replace(replace(t.e_acct_cd,chr(13),''),chr(10),'') as e_acct_cd
    ,replace(replace(t.req_flow_num,chr(13),''),chr(10),'') as req_flow_num
    ,replace(replace(t.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
    ,replace(replace(t.init_entry_flow_num,chr(13),''),chr(10),'') as init_entry_flow_num
    ,replace(replace(t.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
from ${iml_schema}.evt_bs_amt_entry_evt t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bs_amt_entry_evt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
