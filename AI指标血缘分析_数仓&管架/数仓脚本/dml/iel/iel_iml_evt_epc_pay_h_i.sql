: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_epc_pay_h_i
CreateDate: 2021-11-23
FileName:   ${iel_data_path}/evt_epc_pay_h.i.${batch_date}.dat
IF_mark:    f
Logs:
        sundexin 
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.tran_id,chr(13),''),chr(10),'') as tran_id
    ,replace(replace(t.bus_kind_id,chr(13),''),chr(10),'') as bus_kind_id
    ,t.tran_dt as tran_dt
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
    ,replace(replace(t.init_chn_cd,chr(13),''),chr(10),'') as init_chn_cd
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
    ,replace(replace(t.init_teller_id,chr(13),''),chr(10),'') as init_teller_id
    ,t.tran_tm as tran_tm
    ,replace(replace(t.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
    ,t.tran_amt as tran_amt
    ,replace(replace(t.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.cntpty_acct_type_cd,chr(13),''),chr(10),'') as cntpty_acct_type_cd
    ,replace(replace(t.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
    ,replace(replace(t.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
    ,replace(replace(t.sign_id,chr(13),''),chr(10),'') as sign_id
    ,replace(replace(t.pay_flow_num,chr(13),''),chr(10),'') as pay_flow_num
    ,replace(replace(t.pay_status_cd,chr(13),''),chr(10),'') as pay_status_cd
    ,replace(replace(t.tran_return_code,chr(13),''),chr(10),'') as tran_return_code
    ,replace(replace(t.return_info,chr(13),''),chr(10),'') as return_info
    ,replace(replace(t.msg_flow_num,chr(13),''),chr(10),'') as msg_flow_num
    ,replace(replace(t.acpt_pay_instr_cd,chr(13),''),chr(10),'') as acpt_pay_instr_cd
    ,replace(replace(t.msg_id,chr(13),''),chr(10),'') as msg_id
    ,replace(replace(t.init_msg_flow_num,chr(13),''),chr(10),'') as init_msg_flow_num
    ,t.final_update_tm as final_update_tm
    ,t.create_tm as create_tm
    ,replace(replace(t.payer_epc_org_id,chr(13),''),chr(10),'') as payer_epc_org_id
    ,replace(replace(t.recver_epc_org_id,chr(13),''),chr(10),'') as recver_epc_org_id
    ,t.surp_rtnbl_amt as surp_rtnbl_amt
    ,t.host_dt as host_dt
    ,replace(replace(t.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
    ,replace(replace(t.batch_id,chr(13),''),chr(10),'') as batch_id
    ,replace(replace(t.onl_pay_flow_num,chr(13),''),chr(10),'') as onl_pay_flow_num
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.evt_epc_pay_h t
   where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') 
   and to_char(final_update_tm,'yyyymmdd')= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_epc_pay_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes