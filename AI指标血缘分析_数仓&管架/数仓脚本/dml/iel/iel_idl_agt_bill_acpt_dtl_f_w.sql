: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_bill_acpt_dtl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_acpt_dtl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.acpt_dtl_id as acpt_dtl_id
,t.batch_id as batch_id
,t.bill_id as bill_id
,t.task_type_cd as task_type_cd
,t.comm_fee as comm_fee
,t.todos as todos
,t.exp_uncond_pay_entr_cd as exp_uncond_pay_entr_cd
,t.pay_bank_ibank_no as pay_bank_ibank_no
,t.lmt_deduct_amt as lmt_deduct_amt
,t.lmt_ocup_status_cd as lmt_ocup_status_cd
,t.bill_acpt_proc_status_cd as bill_acpt_proc_status_cd
,t.recv_dt as recv_dt
,t.entry_status_cd as entry_status_cd
,t.draw_status_cd as draw_status_cd
,t.recv_opinion_cd as recv_opinion_cd
,t.comm_status_cd as comm_status_cd
,t.bus_flow_num as bus_flow_num
,t.final_modif_tm as final_modif_tm
,t.accptor_agent_reply_cd as accptor_agent_reply_cd
,t.entry_dt as entry_dt
,t.revo_dt as revo_dt
,t.accptor_crdt_level_cd as accptor_crdt_level_cd
,t.accptor_rating_exp_dt as accptor_rating_exp_dt
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_bill_acpt_dtl t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_acpt_dtl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes