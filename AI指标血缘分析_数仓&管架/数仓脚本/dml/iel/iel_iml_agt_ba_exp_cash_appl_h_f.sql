: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ba_exp_cash_appl_h_f
CreateDate: 20221117
FileName:   ${iel_data_path}/agt_ba_exp_cash_appl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,replace(replace(t1.bill_curr_cd,chr(13),''),chr(10),'') as bill_curr_cd
,bill_amt
,replace(replace(t1.msg_appl_type_cd,chr(13),''),chr(10),'') as msg_appl_type_cd
,appl_dt
,replace(replace(t1.sugst_pay_curr_cd,chr(13),''),chr(10),'') as sugst_pay_curr_cd
,cash_amt
,replace(replace(t1.onl_clear_cd,chr(13),''),chr(10),'') as onl_clear_cd
,vouch_qtty
,replace(replace(t1.sugst_payer_cate_cd,chr(13),''),chr(10),'') as sugst_payer_cate_cd
,replace(replace(t1.sugst_payer_orgnz_cd,chr(13),''),chr(10),'') as sugst_payer_orgnz_cd
,replace(replace(t1.sugst_payer_name,chr(13),''),chr(10),'') as sugst_payer_name
,replace(replace(t1.sugst_payer_acct_id,chr(13),''),chr(10),'') as sugst_payer_acct_id
,replace(replace(t1.sugst_payer_open_bank_no,chr(13),''),chr(10),'') as sugst_payer_open_bank_no
,replace(replace(t1.cash_curr_cd,chr(13),''),chr(10),'') as cash_curr_cd
,sugst_pay_appl_dt
,replace(replace(t1.refuse_pay_cd,chr(13),''),chr(10),'') as refuse_pay_cd
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.recv_opinion_cd,chr(13),''),chr(10),'') as recv_opinion_cd
,replace(replace(t1.send_out_recv_status_cd,chr(13),''),chr(10),'') as send_out_recv_status_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,entry_dt
,revo_dt
,replace(replace(t1.pay_tran_num,chr(13),''),chr(10),'') as pay_tran_num
,replace(replace(t1.spec_prmssn_prtcptr_id,chr(13),''),chr(10),'') as spec_prmssn_prtcptr_id
,replace(replace(t1.pos_apv_status_cd,chr(13),''),chr(10),'') as pos_apv_status_cd
,replace(replace(t1.send_pos_flow_num,chr(13),''),chr(10),'') as send_pos_flow_num
,replace(replace(t1.adv_solu_pay_flg,chr(13),''),chr(10),'') as adv_solu_pay_flg
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,tran_dt
,replace(replace(t1.reply_teller_id,chr(13),''),chr(10),'') as reply_teller_id
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.agt_ba_exp_cash_appl_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ba_exp_cash_appl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
