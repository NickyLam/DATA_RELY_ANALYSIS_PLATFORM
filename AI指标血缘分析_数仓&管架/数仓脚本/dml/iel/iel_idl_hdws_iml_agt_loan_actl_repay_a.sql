: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_loan_actl_repay_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_loan_actl_repay.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.repay_seq_num,chr(13),''),chr(10),'') as repay_seq_num
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t1.agt_modf,chr(13),''),chr(10),'') as agt_modf
,t1.curr_term as curr_term
,t1.repay_dt as repay_dt
,t1.etl_dt as etl_dt
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.curr_repay_prcp as curr_repay_prcp
,t1.curr_repay_int as curr_repay_int
,t1.curr_repay_pnlt as curr_repay_pnlt
,t1.curr_repay_compd_int as curr_repay_compd_int
,t1.curr_repay_cost as curr_repay_cost
,t1.curr_bal as curr_bal
,replace(replace(t1.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg
,replace(replace(t1.ovdue_repay_flg,chr(13),''),chr(10),'') as ovdue_repay_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_LOAN_ACTL_REPAY'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_LOAN_ACTL_REPAY') as etl_task_name 
,replace(replace(t1.comp_repay_flg,chr(13),''),chr(10),'') as comp_repay_flg
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,replace(replace(t1.repay_chn_cd,chr(13),''),chr(10),'') as repay_chn_cd
,t1.non_enter_acct_int as non_enter_acct_int
from ${idl_schema}.hdws_iml_agt_loan_actl_repay t1
where (etl_dt <= to_date('${batch_date}','yyyymmdd')-1 and etl_dt >= to_date('20211001','yyyymmdd')-1 and data_src_cd = 'LHWD') OR (etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('20211001','yyyymmdd') and data_src_cd <> 'LHWD');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_loan_actl_repay.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes