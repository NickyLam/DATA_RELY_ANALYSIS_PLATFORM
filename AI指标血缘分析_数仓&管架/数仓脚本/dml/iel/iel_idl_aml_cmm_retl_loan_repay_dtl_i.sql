: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_retl_loan_repay_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_retl_loan_repay_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,acct_id
,dubil_id
,cont_id
,cust_id
,repay_acct_id
,repay_flow_id
,repay_dt
,repaybl_dt
,repay_perds
,repay_sub_perds
,adv_repay_flg
,ovdue_repay_flg
,comp_repay_flg
,bf_repay_status_cd
,repay_post_repay_status_cd
,acru_non_acru_cd
,tran_cd
,curr_cd
,dtl_seq_num
,repay_evt_cd
,repay_evt_descb
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
from ${idl_schema}.aml_cmm_retl_loan_repay_dtl
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_retl_loan_repay_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes