: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_provi_dtl_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_provi_dtl_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.provi_dt,chr(13),''),chr(10),'') as provi_dt
,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t.pric_int_flg,chr(13),''),chr(10),'') as pric_int_flg
,t.int_recvbl as int_recvbl
,t.td_int_recvbl as td_int_recvbl
from ${iml_schema}.agt_loan_provi_dtl t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_provi_dtl_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes