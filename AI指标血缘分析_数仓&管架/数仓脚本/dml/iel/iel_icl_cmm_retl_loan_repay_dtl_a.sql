: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_retl_loan_repay_dtl_a
CreateDate: 20240118
FileName:   ${iel_data_path}/cmm_retl_loan_repay_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t1.repay_flow_id,chr(13),''),chr(10),'') as repay_flow_id
,t1.repay_dt as repay_dt
,t1.repaybl_dt as repaybl_dt
,t1.repay_perds as repay_perds
,t1.repay_sub_perds as repay_sub_perds
,replace(replace(t1.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg
,replace(replace(t1.ovdue_repay_flg,chr(13),''),chr(10),'') as ovdue_repay_flg
,replace(replace(t1.comp_repay_flg,chr(13),''),chr(10),'') as comp_repay_flg
,replace(replace(t1.bf_repay_status_cd,chr(13),''),chr(10),'') as bf_repay_status_cd
,replace(replace(t1.repay_post_repay_status_cd,chr(13),''),chr(10),'') as repay_post_repay_status_cd
,replace(replace(t1.acru_non_acru_cd,chr(13),''),chr(10),'') as acru_non_acru_cd
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.dtl_seq_num,chr(13),''),chr(10),'') as dtl_seq_num
,replace(replace(t1.repay_evt_cd,chr(13),''),chr(10),'') as repay_evt_cd
,replace(replace(t1.repay_evt_descb,chr(13),''),chr(10),'') as repay_evt_descb
,t1.currt_repay_recvbl_acru_int as currt_repay_recvbl_acru_int
,t1.currt_repay_coll_acru_int as currt_repay_coll_acru_int
,t1.currt_repay_recvbl_over_int as currt_repay_recvbl_over_int
,t1.currt_repay_coll_over_int as currt_repay_coll_over_int
,t1.currt_repay_recvbl_acru_pnlt as currt_repay_recvbl_acru_pnlt
,t1.currt_repay_coll_acru_pnlt as currt_repay_coll_acru_pnlt
,t1.currt_repay_recvbl_pnlt as currt_repay_recvbl_pnlt
,t1.currt_repay_coll_pnlt as currt_repay_coll_pnlt
,t1.currt_repay_acru_comp_int as currt_repay_acru_comp_int
,t1.currt_repay_recvbl_comp_int as currt_repay_recvbl_comp_int
,t1.currt_fine as currt_fine
,t1.currt_wrt_off_int as currt_wrt_off_int
,t1.curr_nomal_pric_bal as curr_nomal_pric_bal
,t1.currt_repay_pric as currt_repay_pric
,t1.currt_repay_int as currt_repay_int
,t1.currt_repay_pnlt as currt_repay_pnlt
,t1.currt_repay_comp_int as currt_repay_comp_int
,t1.currt_repay_fee as currt_repay_fee
,t1.unbd_int as unbd_int
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.strk_bal_flg,chr(13),''),chr(10),'') as strk_bal_flg
from ${icl_schema}.cmm_retl_loan_repay_dtl t1
where etl_dt <= to_date('${batch_date}', 'yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_repay_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes