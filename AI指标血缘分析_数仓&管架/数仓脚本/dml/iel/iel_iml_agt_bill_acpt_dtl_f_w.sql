: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_acpt_dtl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_acpt_dtl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.etl_dt as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acpt_dtl_id,chr(13),''),chr(10),'') as acpt_dtl_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,t1.comm_fee as comm_fee
,t1.todos as todos
,replace(replace(t1.exp_uncond_pay_entr_cd,chr(13),''),chr(10),'') as exp_uncond_pay_entr_cd
,replace(replace(t1.pay_bank_ibank_no,chr(13),''),chr(10),'') as pay_bank_ibank_no
,t1.lmt_deduct_amt as lmt_deduct_amt
,replace(replace(t1.bill_acpt_proc_status_cd,chr(13),''),chr(10),'') as bill_acpt_proc_status_cd
,t1.recv_dt as recv_dt
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.recv_opinion_cd,chr(13),''),chr(10),'') as recv_opinion_cd
,t1.final_modif_tm as final_modif_tm
,replace(replace(t1.accptor_agent_reply_cd,chr(13),''),chr(10),'') as accptor_agent_reply_cd
,t1.entry_dt as entry_dt
,t1.revo_dt as revo_dt
,replace(replace(t1.draw_status_cd,chr(13),''),chr(10),'') as draw_status_cd
,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'') as payoff_flg
,replace(replace(t1.bill_pkg_intrv_id,chr(13),''),chr(10),'') as bill_pkg_intrv_id
,t1.bill_amt as bill_amt
,t1.bill_intrv_corp_amt as bill_intrv_corp_amt
,t1.bill_intrv_qtty as bill_intrv_qtty
,replace(replace(t1.h_data_flg,chr(13),''),chr(10),'') as h_data_flg
,replace(replace(t1.crdt_out_acct_flow_num,chr(13),''),chr(10),'') as crdt_out_acct_flow_num
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
from ${iml_schema}.agt_bill_acpt_dtl t1 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_acpt_dtl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes