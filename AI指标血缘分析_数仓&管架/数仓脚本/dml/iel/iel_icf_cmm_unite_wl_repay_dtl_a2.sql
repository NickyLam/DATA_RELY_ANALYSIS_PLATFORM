: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_unite_wl_repay_dtl_a
CreateDate: 20250812
FileName:   ${iel_data_path}/cmm_unite_wl_repay_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.etl_dt + 1
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t1.repay_flow_id,chr(13),''),chr(10),'') as repay_flow_id
,t1.repay_dt as repay_dt
,replace(replace(t1.intnal_carr_flg,chr(13),''),chr(10),'') as intnal_carr_flg
,replace(replace(t1.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg
,replace(replace(t1.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg
,replace(replace(t1.ovdue_repay_flg,chr(13),''),chr(10),'') as ovdue_repay_flg
,replace(replace(t1.acru_non_acru_cd,chr(13),''),chr(10),'') as acru_non_acru_cd
,replace(replace(t1.repay_type_cd,chr(13),''),chr(10),'') as repay_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.curr_nomal_pric_bal as curr_nomal_pric_bal
,t1.currt_repay_amt as currt_repay_amt
,t1.currt_repay_pric as currt_repay_pric
,t1.currt_repay_nomal_pric as currt_repay_nomal_pric
,t1.currt_repay_ovdue_pric as currt_repay_ovdue_pric
,t1.curr_repay_int as curr_repay_int
,t1.currt_repay_nomal_int as currt_repay_nomal_int
,t1.currt_repay_ovdue_int as currt_repay_ovdue_int
,t1.currt_repay_pnlt as currt_repay_pnlt
,t1.currt_repay_ovdue_pric_pnlt as currt_repay_ovdue_pric_pnlt
,t1.currt_repay_ovdue_int_pnlt as currt_repay_ovdue_int_pnlt
,t1.currt_repay_fee as currt_repay_fee
,t1.currt_repay_fee_rat as currt_repay_fee_rat
,t1.bf_repay_recvbl_uncol_nomal_pric as bf_repay_recvbl_uncol_nomal_pric
,t1.bf_repay_recvbl_uncol_ovdue_pric as bf_repay_recvbl_uncol_ovdue_pric
,t1.bf_repay_recvbl_uncol_nomal_int as bf_repay_recvbl_uncol_nomal_int
,t1.bf_repay_recvbl_uncol_ovdue_int as bf_repay_recvbl_uncol_ovdue_int
,t1.bf_repay_recvbl_uncol_ovdue_pric_pnlt as bf_repay_recvbl_uncol_ovdue_pric_pnlt
,t1.bf_repay_recvbl_uncol_ovdue_int_pnlt as bf_repay_recvbl_uncol_ovdue_int_pnlt
from ${icl_schema}.cmm_unite_wl_repay_dtl t1
where etl_dt >= to_date('20241231','yyyymmdd') and etl_dt <= to_date('${batch_date}','yyyymmdd')-1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_unite_wl_repay_dtl.a.${batch_date}.dat" \
        charset=utf8
        safe=yes