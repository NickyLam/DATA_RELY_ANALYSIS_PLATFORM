: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_corp_loan_int_adj_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_corp_loan_int_adj_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.ser_num,chr(13),''),chr(10),'') as ser_num
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
    ,t.int_accr_start_dt as int_accr_start_dt
    ,t.int_accr_end_dt as int_accr_end_dt
    ,t.int_accr_amt as int_accr_amt
    ,t.int_accr_accum as int_accr_accum
    ,t.int_rat as int_rat
    ,t.int_adj_amt as int_adj_amt
    ,t.adj_dt as adj_dt
    ,replace(replace(t.adj_ser_num,chr(13),''),chr(10),'') as adj_ser_num
    ,replace(replace(t.int_type_cd,chr(13),''),chr(10),'') as int_type_cd
    ,t.int_set_dt as int_set_dt
    ,t.init_over_int_bal as init_over_int_bal
    ,t.new_over_int_bal as new_over_int_bal
    ,replace(replace(t.adj_rs_descb,chr(13),''),chr(10),'') as adj_rs_descb
from iml.evt_corp_loan_int_adj_dtl t
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_corp_loan_int_adj_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes