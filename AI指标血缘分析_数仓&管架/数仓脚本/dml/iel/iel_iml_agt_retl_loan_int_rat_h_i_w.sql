: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_retl_loan_int_rat_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_int_rat_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.int_accr_dtl_seq_num,chr(13),''),chr(10),'') as int_accr_dtl_seq_num
,t.init_exec_int_rat as init_exec_int_rat
,t.exec_int_rat as exec_int_rat
,t.init_ovdue_int_rat as init_ovdue_int_rat
,t.ovdue_int_rat as ovdue_int_rat
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.tran_dt as tran_dt
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_retl_loan_int_rat_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_int_rat_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes