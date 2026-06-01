: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_retl_loan_acct_ic_tran_dtl_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_retl_loan_acct_ic_tran_dtl_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,t.tran_dt as tran_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.dtl_id,chr(13),''),chr(10),'') as dtl_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,t.curr_perds as curr_perds
,t.curr_sub_perds as curr_sub_perds
,t.rpbl_dt as rpbl_dt
,replace(replace(t.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t.repay_kind_cd,chr(13),''),chr(10),'') as repay_kind_cd
,t.pric_amt as pric_amt
,t.recvbl_acru_int_amt as recvbl_acru_int_amt
,t.coll_acru_int_amt as coll_acru_int_amt
,t.recvbl_over_int_amt as recvbl_over_int_amt
,t.coll_over_int_amt as coll_over_int_amt
,t.recvbl_acru_pnlt_amt as recvbl_acru_pnlt_amt
,t.coll_acru_pnlt_amt as coll_acru_pnlt_amt
,t.recvbl_pnlt_amt as recvbl_pnlt_amt
,t.coll_pnlt_amt as coll_pnlt_amt
,t.acru_comp_int_amt as acru_comp_int_amt
,t.comp_int_amt as comp_int_amt
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.tran_cd,chr(13),''),chr(10),'') as tran_cd
,t.fine_amt as fine_amt
,t.wrt_off_int_amt as wrt_off_int_amt
,replace(replace(t.ic_status_cd,chr(13),''),chr(10),'') as ic_status_cd
,replace(replace(t.acru_non_acru_flg_cd,chr(13),''),chr(10),'') as acru_non_acru_flg_cd
,replace(replace(t.tran_evt,chr(13),''),chr(10),'') as tran_evt
,replace(replace(t.evt_comnt,chr(13),''),chr(10),'') as evt_comnt
from ${iml_schema}.evt_retl_loan_acct_ic_tran_dtl t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_retl_loan_acct_ic_tran_dtl_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes