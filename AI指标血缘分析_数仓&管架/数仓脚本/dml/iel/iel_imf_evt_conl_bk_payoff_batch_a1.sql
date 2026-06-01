: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_conl_bk_payoff_batch_a1
CreateDate: 20250305
FileName:   ${iel_data_path}/evt_conl_bk_payoff_batch.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,batch_dt
,replace(replace(t1.payoff_kind_cd,chr(13),''),chr(10),'') as payoff_kind_cd
,chn_dt
,replace(replace(t1.chn_seq_num,chr(13),''),chr(10),'') as chn_seq_num
,replace(replace(t1.batch_doc_id,chr(13),''),chr(10),'') as batch_doc_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.tran_out_acct_id,chr(13),''),chr(10),'') as tran_out_acct_id
,replace(replace(t1.tran_out_acct_name,chr(13),''),chr(10),'') as tran_out_acct_name
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tot_qtty
,sucs_tot_qtty
,fail_tot_qtty
,tot_amt
,sucs_tot_amt
,fail_tot_amt
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,replace(replace(t1.need_acct_tran_flg,chr(13),''),chr(10),'') as need_acct_tran_flg
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.tran_acct_name,chr(13),''),chr(10),'') as tran_acct_name
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
,replace(replace(t1.flow_status_cd,chr(13),''),chr(10),'') as flow_status_cd
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
,replace(replace(t1.cntpty_acct_bank_out_flg,chr(13),''),chr(10),'') as cntpty_acct_bank_out_flg
,replace(replace(t1.corp_acct_bank_out_flg,chr(13),''),chr(10),'') as corp_acct_bank_out_flg
,replace(replace(t1.tran_inside_acct_acct_num,chr(13),''),chr(10),'') as tran_inside_acct_acct_num
,replace(replace(t1.tran_inside_acct_name,chr(13),''),chr(10),'') as tran_inside_acct_name
,replace(replace(t1.core_prpery_flow_num,chr(13),''),chr(10),'') as core_prpery_flow_num
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,core_entry_dt
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.re_payoff_sys_cd,chr(13),''),chr(10),'') as re_payoff_sys_cd

from ${iml_schema}.evt_conl_bk_payoff_batch t1
where etl_dt between date'2025-02-01' and to_date('${batch_date}','yyyymmdd'); " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_conl_bk_payoff_batch.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
