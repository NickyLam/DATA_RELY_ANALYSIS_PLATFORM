: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_bill_acpt_dtl_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_bill_acpt_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.agt_id as agt_id
,t1.lp_id as lp_id
,t1.acpt_dtl_id as acpt_dtl_id
,t1.batch_id as batch_id
,t1.bill_id as bill_id
,t1.comm_fee as comm_fee
,t1.todos as todos
,t1.exp_uncond_pay_entr_cd as exp_uncond_pay_entr_cd
,t1.pay_bank_ibank_no as pay_bank_ibank_no
,t1.lmt_deduct_amt as lmt_deduct_amt
,t1.bill_acpt_proc_status_cd as bill_acpt_proc_status_cd
,t1.recv_dt as recv_dt
,t1.entry_status_cd as entry_status_cd
,t1.recv_opinion_cd as recv_opinion_cd
,t1.final_modif_tm as final_modif_tm
,t1.accptor_agent_reply_cd as accptor_agent_reply_cd
,t1.entry_dt as entry_dt
,t1.revo_dt as revo_dt
,t1.draw_status_cd as draw_status_cd
,t1.payoff_flg as payoff_flg
,t1.bill_pkg_intrv_id as bill_pkg_intrv_id
,t1.bill_amt as bill_amt
,t1.bill_intrv_corp_amt as bill_intrv_corp_amt
,t1.bill_intrv_qtty as bill_intrv_qtty
,t1.crdt_out_acct_flow_num as crdt_out_acct_flow_num
,t1.h_data_flg as h_data_flg
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark

from ${idl_schema}.oass_agt_bill_acpt_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_bill_acpt_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
