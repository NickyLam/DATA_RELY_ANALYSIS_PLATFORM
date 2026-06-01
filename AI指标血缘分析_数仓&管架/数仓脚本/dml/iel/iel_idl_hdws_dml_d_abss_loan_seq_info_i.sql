: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dml_d_abss_loan_seq_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dml_d_abss_loan_seq_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.etl_dt as etl_dt
,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t.asset_src,chr(13),''),chr(10),'') as asset_src
,t.repay_term as repay_term
,replace(replace(t.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,t.repay_dt as repay_dt
,replace(replace(t.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t.repay_total_amt as repay_total_amt
,t.paid_prcp as paid_prcp
,t.rema_prcp_bal as rema_prcp_bal
,t.paid_int as paid_int
,t.paid_prcp_pnlt as paid_prcp_pnlt
,t.paid_int_pnlt as paid_int_pnlt
,t.adv_repay_prcp as adv_repay_prcp
,t.adv_pnty as adv_pnty
,t.adv_repay_int as adv_repay_int
from ${idl_schema}.hdws_dml_d_abss_loan_seq_info t
where t.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dml_d_abss_loan_seq_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes