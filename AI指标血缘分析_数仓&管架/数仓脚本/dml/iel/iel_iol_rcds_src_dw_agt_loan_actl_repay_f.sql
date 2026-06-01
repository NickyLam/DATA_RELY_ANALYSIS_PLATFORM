: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_src_dw_agt_loan_actl_repay_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_src_dw_agt_loan_actl_repay.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.repay_seq_num,chr(13),''),chr(10),'') as repay_seq_num
    ,replace(replace(t.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
    ,t.curr_term as curr_term
    ,t.repay_dt as repay_dt
    ,t.etl_dt_ora as etl_dt_ora
    ,replace(replace(t.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
    ,replace(replace(t.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
    ,t.curr_repay_prcp as curr_repay_prcp
    ,t.curr_repay_int as curr_repay_int
    ,t.curr_repay_pnlt as curr_repay_pnlt
    ,t.curr_repay_compd_int as curr_repay_compd_int
    ,t.curr_repay_cost as curr_repay_cost
    ,t.curr_bal as curr_bal
    ,replace(replace(t.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg
    ,replace(replace(t.ovdue_repay_flg,chr(13),''),chr(10),'') as ovdue_repay_flg
    ,replace(replace(t.comp_repay_flg,chr(13),''),chr(10),'') as comp_repay_flg
    ,replace(replace(t.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
    ,replace(replace(t.repay_chn_cd,chr(13),''),chr(10),'') as repay_chn_cd
    ,replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
    ,replace(replace(t.del_flg,chr(13),''),chr(10),'') as del_flg
from iol.rcds_src_dw_agt_loan_actl_repay t    
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_src_dw_agt_loan_actl_repay.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes