: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_retl_loan_repay_dtl_i
CreateDate: 20241219
FileName:   ${iel_data_path}/cmm_retl_loan_repay_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t1.repay_flow_id,chr(13),''),chr(10),'') as repay_flow_id
,repay_dt
,repaybl_dt
,repay_perds
,repay_sub_perds
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
,currt_repay_recvbl_acru_int
,currt_repay_coll_acru_int
,currt_repay_recvbl_over_int
,currt_repay_coll_over_int
,currt_repay_recvbl_acru_pnlt
,currt_repay_coll_acru_pnlt
,currt_repay_recvbl_pnlt
,currt_repay_coll_pnlt
,currt_repay_acru_comp_int
,currt_repay_recvbl_comp_int
,currt_fine
,currt_wrt_off_int
,curr_nomal_pric_bal
,currt_repay_pric
,currt_repay_int
,currt_repay_pnlt
,currt_repay_comp_int
,currt_repay_fee
,unbd_int
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.strk_bal_flg,chr(13),''),chr(10),'') as strk_bal_flg
,replace(replace(t1.callbk_mode_cd,chr(13),''),chr(10),'') as callbk_mode_cd

from ${icl_schema}.cmm_retl_loan_repay_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_repay_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
