: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crps_cmm_unite_wl_repay_dtl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/crps_cmm_unite_wl_repay_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,dubil_id
,cust_id
,prod_id
,repay_acct_id
,repay_flow_id
,repay_dt
,intnal_carr_flg
,wrt_off_flg
,adv_repay_flg
,ovdue_repay_flg
,acru_non_acru_cd
,repay_type_cd
,curr_cd
,curr_nomal_pric_bal
,currt_repay_amt
,currt_repay_pric
,currt_repay_nomal_pric
,currt_repay_ovdue_pric
,curr_repay_int
,currt_repay_nomal_int
,currt_repay_ovdue_int
,currt_repay_pnlt
,currt_repay_ovdue_pric_pnlt
,currt_repay_ovdue_int_pnlt
,currt_repay_fee
,currt_repay_fee_rat
,bf_repay_recvbl_uncol_nomal_pric
,bf_repay_recvbl_uncol_ovdue_pric
,bf_repay_recvbl_uncol_nomal_int
,bf_repay_recvbl_uncol_ovdue_int
,bf_repay_recvbl_uncol_ovdue_pric_pnlt
,bf_repay_recvbl_uncol_ovdue_int_pnlt
from icl.cmm_unite_wl_repay_dtl t1
where t1.etl_dt >= to_date('20230101','yyyymmdd') AND t1.etl_dt <= to_date('20230430','yyyymmdd'); " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_cmm_unite_wl_repay_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes