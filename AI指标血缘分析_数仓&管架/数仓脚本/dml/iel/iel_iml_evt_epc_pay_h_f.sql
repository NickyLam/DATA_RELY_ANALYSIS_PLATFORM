: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_epc_pay_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_epc_pay_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.bus_kind_id,chr(13),''),chr(10),'') as bus_kind_id
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.init_chn_cd,chr(13),''),chr(10),'') as init_chn_cd
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.init_teller_id,chr(13),''),chr(10),'') as init_teller_id
,t1.tran_tm as tran_tm
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,t1.tran_amt as tran_amt
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cntpty_acct_type_cd,chr(13),''),chr(10),'') as cntpty_acct_type_cd
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.sign_id,chr(13),''),chr(10),'') as sign_id
,replace(replace(t1.pay_flow_num,chr(13),''),chr(10),'') as pay_flow_num
,replace(replace(t1.pay_status_cd,chr(13),''),chr(10),'') as pay_status_cd
,replace(replace(t1.tran_return_code,chr(13),''),chr(10),'') as tran_return_code
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,replace(replace(t1.msg_flow_num,chr(13),''),chr(10),'') as msg_flow_num
,replace(replace(t1.acpt_pay_instr_cd,chr(13),''),chr(10),'') as acpt_pay_instr_cd
,replace(replace(t1.msg_id,chr(13),''),chr(10),'') as msg_id
,replace(replace(t1.init_msg_flow_num,chr(13),''),chr(10),'') as init_msg_flow_num
,t1.final_update_tm as final_update_tm
,t1.create_tm as create_tm
,replace(replace(t1.payer_epc_org_id,chr(13),''),chr(10),'') as payer_epc_org_id
,replace(replace(t1.recver_epc_org_id,chr(13),''),chr(10),'') as recver_epc_org_id
,t1.surp_rtnbl_amt as surp_rtnbl_amt
,t1.host_dt as host_dt
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.onl_pay_flow_num,chr(13),''),chr(10),'') as onl_pay_flow_num
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.evt_epc_pay_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_epc_pay_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes