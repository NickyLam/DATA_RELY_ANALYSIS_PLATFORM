: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_retl_loan_acct_ic_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_acct_ic_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.pd_num,chr(13),''),chr(10),'') as pd_num
,t.sub_perds as sub_perds
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,t.begin_dt as begin_dt
,t.exp_dt as exp_dt
,t.grace_period_exp_dt as grace_period_exp_dt
,t.last_repay_dt as last_repay_dt
,t.next_repay_dt as next_repay_dt
,t.init_pric as init_pric
,t.init_int as init_int
,t.pric_amt as pric_amt
,t.recvbl_acru_int as recvbl_acru_int
,t.coll_acru_int as coll_acru_int
,t.recvbl_over_int as recvbl_over_int
,t.coll_over_int as coll_over_int
,t.recvbl_acru_pnlt as recvbl_acru_pnlt
,t.coll_acru_pnlt as coll_acru_pnlt
,t.recvbl_pnlt as recvbl_pnlt
,t.coll_pnlt as coll_pnlt
,t.acru_comp_int as acru_comp_int
,t.comp_int as comp_int
,t.wrt_off_int as wrt_off_int
,t.actl_acru_int as actl_acru_int
,t.actl_acru_pnlt as actl_acru_pnlt
,t.actl_acru_comp_int as actl_acru_comp_int
,t.acru_int_sub as acru_int_sub
,t.recvbl_int_sub as recvbl_int_sub
,t.recvbl_fee as recvbl_fee
,t.recvbl_fine as recvbl_fine
,replace(replace(t.curr_issue_status_cd,chr(13),''),chr(10),'') as curr_issue_status_cd
,replace(replace(t.acru_non_acru_status_cd,chr(13),''),chr(10),'') as acru_non_acru_status_cd
,replace(replace(t.ic_kind_cd,chr(13),''),chr(10),'') as ic_kind_cd
,t.base_start_dt as base_start_dt
,t.base_exp_dt as base_exp_dt
,replace(replace(t.dtl_seq_num,chr(13),''),chr(10),'') as dtl_seq_num
,t.matn_dt as matn_dt
,replace(replace(t.matn_teller_id,chr(13),''),chr(10),'') as matn_teller_id
,replace(replace(t.matn_org_id,chr(13),''),chr(10),'') as matn_org_id
,replace(replace(t.matn_tm,chr(13),''),chr(10),'') as matn_tm
,replace(replace(t.tm_stamp,chr(13),''),chr(10),'') as tm_stamp
,replace(replace(t.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_retl_loan_acct_ic_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_acct_ic_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes