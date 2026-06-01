: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_retl_repay_plan_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_repay_plan_h_w.i.${batch_date}.dat
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
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.value_dt as value_dt
,t.repay_dt as repay_dt
,t.last_repay_day as last_repay_day
,t.next_repay_day as next_repay_day
,t.pric_bal as pric_bal
,t.rpbl_pric as rpbl_pric
,t.rpbl_int as rpbl_int
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
,replace(replace(t.repay_type_cd,chr(13),''),chr(10),'') as repay_type_cd
,replace(replace(t.repay_status_cd,chr(13),''),chr(10),'') as repay_status_cd
,replace(replace(t.curr_issue_status_cd,chr(13),''),chr(10),'') as curr_issue_status_cd
,t.modif_dt as modif_dt
,t.grace_dt as grace_dt
,t.exec_int_rat as exec_int_rat
,t.curr_pric_amt as curr_pric_amt
,t.ic_amt as ic_amt
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_retl_repay_plan_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_repay_plan_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes