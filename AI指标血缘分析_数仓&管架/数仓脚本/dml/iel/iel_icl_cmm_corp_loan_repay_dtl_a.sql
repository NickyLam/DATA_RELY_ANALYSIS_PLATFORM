: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_loan_repay_dtl_a
CreateDate: 20251121
FileName:   ${iel_data_path}/cmm_corp_loan_repay_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t1.repay_flow_id,chr(13),''),chr(10),'') as repay_flow_id
,repay_dt
,repay_perds
,replace(replace(t1.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg
,replace(replace(t1.ovdue_repay_flg,chr(13),''),chr(10),'') as ovdue_repay_flg
,replace(replace(t1.repay_chn_cd,chr(13),''),chr(10),'') as repay_chn_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,curr_nomal_pric_bal
,currt_adv_repay_pric
,currt_repay_pric
,currt_repay_int
,currt_repay_pnlt
,currt_repay_comp_int
,currt_repay_fee
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.strk_bal_flg,chr(13),''),chr(10),'') as strk_bal_flg
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.dtl_seq_num,chr(13),''),chr(10),'') as dtl_seq_num
,replace(replace(t1.repay_type_cd,chr(13),''),chr(10),'') as repay_type_cd

from ${icl_schema}.cmm_corp_loan_repay_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_loan_repay_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
