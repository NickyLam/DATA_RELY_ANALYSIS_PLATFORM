: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_conl_bk_payoff_dtl_a1
CreateDate: 20250305
FileName:   ${iel_data_path}/evt_conl_bk_payoff_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,batch_dt
,replace(replace(t1.rec_id,chr(13),''),chr(10),'') as rec_id
,chn_dt
,replace(replace(t1.chn_seq_num,chr(13),''),chr(10),'') as chn_seq_num
,replace(replace(t1.conl_bk_tran_type_cd,chr(13),''),chr(10),'') as conl_bk_tran_type_cd
,replace(replace(t1.dtl_acct_id,chr(13),''),chr(10),'') as dtl_acct_id
,replace(replace(t1.dtl_acct_name,chr(13),''),chr(10),'') as dtl_acct_name
,tran_amt
,tran_sucs_amt
,replace(replace(t1.deduct_mode_cd,chr(13),''),chr(10),'') as deduct_mode_cd
,replace(replace(t1.core_memo_cd,chr(13),''),chr(10),'') as core_memo_cd
,replace(replace(t1.corp_agent_acct,chr(13),''),chr(10),'') as corp_agent_acct
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,core_tran_dt
,replace(replace(t1.resp_code,chr(13),''),chr(10),'') as resp_code
,replace(replace(t1.resp_code_descb,chr(13),''),chr(10),'') as resp_code_descb
,replace(replace(t1.cntpty_acct_bank_num,chr(13),''),chr(10),'') as cntpty_acct_bank_num
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
,replace(replace(t1.unify_pay_order_no,chr(13),''),chr(10),'') as unify_pay_order_no
,replace(replace(t1.unify_pay_flow_num,chr(13),''),chr(10),'') as unify_pay_flow_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num

from ${iml_schema}.evt_conl_bk_payoff_dtl t1
where etl_dt between date'2025-02-01' and to_date('${batch_date}','yyyymmdd'); " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_conl_bk_payoff_dtl.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
