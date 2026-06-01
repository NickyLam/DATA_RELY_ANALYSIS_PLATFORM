: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_corp_loan_bal_dtl_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_corp_loan_bal_dtl_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.bal_seq_num,chr(13),''),chr(10),'') as bal_seq_num
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.bal_compnt_type_cd,chr(13),''),chr(10),'') as bal_compnt_type_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.int_accr_bal_seq_num,chr(13),''),chr(10),'') as int_accr_bal_seq_num
,t.term_num as term_num
,replace(replace(t.repay_ps_type_cd,chr(13),''),chr(10),'') as repay_ps_type_cd
,t.enter_acct_dt as enter_acct_dt
,replace(replace(t.enter_acct_flow_num,chr(13),''),chr(10),'') as enter_acct_flow_num
,t.enter_acct_amt as enter_acct_amt
,replace(replace(t.int_on_acct_int_accr_lt_num,chr(13),''),chr(10),'') as int_on_acct_int_accr_lt_num
,t.int_accr_start_dt as int_accr_start_dt
,t.int_accr_end_dt as int_accr_end_dt
,t.bal as bal
,t.value_dt as value_dt
,t.exp_dt as exp_dt
,t.accum_dt as accum_dt
,t.int_accr_accum as int_accr_accum
,t.currt_unpay_int as currt_unpay_int
,t.seg_unpay_int as seg_unpay_int
,t.wrtoff_dt as wrtoff_dt
,replace(replace(t.wrtoff_flow_num,chr(13),''),chr(10),'') as wrtoff_flow_num
,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
,t.rol_acct_bf_bal as rol_acct_bf_bal
,replace(replace(t.int_cate_cd,chr(13),''),chr(10),'') as int_cate_cd
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_corp_loan_bal_dtl_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_corp_loan_bal_dtl_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes