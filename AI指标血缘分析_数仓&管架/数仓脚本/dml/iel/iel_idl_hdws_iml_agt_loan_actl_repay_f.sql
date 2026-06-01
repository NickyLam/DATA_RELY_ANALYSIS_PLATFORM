: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_loan_actl_repay_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_loan_actl_repayf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.data_src_cd
,t.repay_seq_num
,t.loan_acct_id
,t.curr_term
,t.repay_dt
,t.etl_dt
,t.blng_pty_id
,t.ccy_cd
,t.curr_repay_prcp
,t.curr_repay_int
,t.curr_repay_pnlt
,t.curr_repay_compd_int
,t.curr_repay_cost
,t.curr_bal
,t.adv_repay_flg
,t.ovdue_repay_flg
,t.comp_repay_flg 
,t.repay_acct_id
,t.repay_chn_cd
,t.non_enter_acct_int
from idl.hdws_iml_agt_loan_actl_repay t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_loan_actl_repayf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes