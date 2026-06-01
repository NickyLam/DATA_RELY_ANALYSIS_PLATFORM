: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_retl_loan_int_accr_dtl_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_int_accr_dtl_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.recvbl_acru_int as recvbl_acru_int
,t.recvbl_acru_int_amt as recvbl_acru_int_amt
,t.coll_acru_int as coll_acru_int
,t.coll_acru_int_amt as coll_acru_int_amt
,t.recvbl_acru_pnlt as recvbl_acru_pnlt
,t.recvbl_acru_pnlt_amt as recvbl_acru_pnlt_amt
,t.coll_acru_pnlt as coll_acru_pnlt
,t.coll_acru_pnlt_amt as coll_acru_pnlt_amt
,t.acru_comp_int as acru_comp_int
,t.acru_comp_int_amt as acru_comp_int_amt
,t.int_accr_dt as int_accr_dt
,t.job_cd
from ${iml_schema}.agt_retl_loan_int_accr_dtl t 
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_int_accr_dtl_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes