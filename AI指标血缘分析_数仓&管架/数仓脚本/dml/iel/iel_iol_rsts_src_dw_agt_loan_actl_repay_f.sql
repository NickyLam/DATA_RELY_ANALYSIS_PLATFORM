: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_src_dw_agt_loan_actl_repay_f
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_src_dw_agt_loan_actl_repay.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.repay_seq_num,chr(13),''),chr(10),'') as repay_seq_num
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,curr_term
,repay_dt
,etl_dt_ora
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,curr_repay_prcp
,curr_repay_int
,curr_repay_pnlt
,curr_repay_compd_int
,curr_repay_cost
,curr_bal
,replace(replace(t1.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg
,replace(replace(t1.ovdue_repay_flg,chr(13),''),chr(10),'') as ovdue_repay_flg
,replace(replace(t1.comp_repay_flg,chr(13),''),chr(10),'') as comp_repay_flg
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t1.repay_chn_cd,chr(13),''),chr(10),'') as repay_chn_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg

from ${iol_schema}.rsts_src_dw_agt_loan_actl_repay t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_src_dw_agt_loan_actl_repay.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
