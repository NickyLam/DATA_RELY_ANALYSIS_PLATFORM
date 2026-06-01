: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_retl_loan_cust_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_retl_loan_cust_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date(${batch_date},'yyyymmdd') as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.tran_dt as tran_dt
,replace(replace(t.dtl_id,chr(13),''),chr(10),'') as dtl_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.distr_acct_id,chr(13),''),chr(10),'') as distr_acct_id
,replace(replace(t.distr_cap_proc_way_cd,chr(13),''),chr(10),'') as distr_cap_proc_way_cd
,replace(replace(t.repay_kind_cd,chr(13),''),chr(10),'') as repay_kind_cd
,t.repaid_pric as repaid_pric
,t.repaid_recvbl_acru_int as repaid_recvbl_acru_int
,t.repaid_recvbl_over_int as repaid_recvbl_over_int
,t.repaid_recvbl_acru_pnlt as repaid_recvbl_acru_pnlt
,t.repaid_acru_comp_int as repaid_acru_comp_int
,t.repaid_fee as repaid_fee
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.tran_evt_cd,chr(13),''),chr(10),'') as tran_evt_cd
,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
,t.distr_amt as distr_amt
,replace(replace(t.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,t.repaid_coll_acru_int as repaid_coll_acru_int
,t.repaid_coll_over_int as repaid_coll_over_int
,t.repaid_coll_acru_pnlt as repaid_coll_acru_pnlt
,t.repaid_recvbl_pnlt as repaid_recvbl_pnlt
,t.repaid_coll_pnlt as repaid_coll_pnlt
,t.repaid_comp_int as repaid_comp_int
,replace(replace(t.tran_code,chr(13),''),chr(10),'') as tran_code
,t.repay_tot as repay_tot
 from iml.evt_retl_loan_cust_tran_dtl t 
 where t.etl_dt = to_date(${batch_date},'yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_retl_loan_cust_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes