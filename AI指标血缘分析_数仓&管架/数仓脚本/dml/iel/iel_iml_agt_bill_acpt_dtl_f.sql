: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_acpt_dtl_f
CreateDate: 20230423
FileName:   ${iel_data_path}/agt_bill_acpt_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acpt_dtl_id,chr(13),''),chr(10),'') as acpt_dtl_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,comm_fee
,todos
,replace(replace(t1.exp_uncond_pay_entr_cd,chr(13),''),chr(10),'') as exp_uncond_pay_entr_cd
,replace(replace(t1.pay_bank_ibank_no,chr(13),''),chr(10),'') as pay_bank_ibank_no
,lmt_deduct_amt
,replace(replace(t1.bill_acpt_proc_status_cd,chr(13),''),chr(10),'') as bill_acpt_proc_status_cd
,recv_dt
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.recv_opinion_cd,chr(13),''),chr(10),'') as recv_opinion_cd
,final_modif_tm
,replace(replace(t1.accptor_agent_reply_cd,chr(13),''),chr(10),'') as accptor_agent_reply_cd
,entry_dt
,revo_dt
,replace(replace(t1.draw_status_cd,chr(13),''),chr(10),'') as draw_status_cd
,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'') as payoff_flg
,replace(replace(t1.bill_pkg_intrv_id,chr(13),''),chr(10),'') as bill_pkg_intrv_id
,bill_amt
,bill_intrv_corp_amt
,bill_intrv_qtty
,replace(replace(t1.h_data_flg,chr(13),''),chr(10),'') as h_data_flg
,replace(replace(t1.crdt_out_acct_flow_num,chr(13),''),chr(10),'') as crdt_out_acct_flow_num
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.agt_bill_acpt_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_acpt_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
