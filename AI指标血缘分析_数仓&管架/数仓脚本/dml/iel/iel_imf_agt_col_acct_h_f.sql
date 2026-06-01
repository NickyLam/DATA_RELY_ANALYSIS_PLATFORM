: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_col_acct_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_col_acct_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.tran_seq_num,chr(13),''),chr(10),'') as tran_seq_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.col_type_cd,chr(13),''),chr(10),'') as col_type_cd
,replace(replace(t1.acpt_pay_idf_cd,chr(13),''),chr(10),'') as acpt_pay_idf_cd
,replace(replace(t1.col_rgst_b_type_cd,chr(13),''),chr(10),'') as col_rgst_b_type_cd
,t1.col_amt as col_amt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,t1.tran_dt as tran_dt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.tran_tm as tran_tm
from ${iml_schema}.agt_col_acct_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_col_acct_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes