: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_dep_pay_int_flow_i_q
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_dep_pay_int_flow_q.i.${batch_date}.dat
IF_mark:    i_q
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.int_amt as int_amt
,replace(replace(t1.in_int_acct_id,chr(13),''),chr(10),'') as in_int_acct_id
,replace(replace(t1.acct_belong_org_id,chr(13),''),chr(10),'') as acct_belong_org_id
,replace(replace(t1.dep_acct_id,chr(13),''),chr(10),'') as dep_acct_id
,replace(replace(t1.dep_main_acct_id,chr(13),''),chr(10),'') as dep_main_acct_id
,replace(replace(t1.dep_sub_acct_id,chr(13),''),chr(10),'') as dep_sub_acct_id
,replace(replace(t1.accti_cd,chr(13),''),chr(10),'') as accti_cd
,replace(replace(t1.int_expns_type_cd,chr(13),''),chr(10),'') as int_expns_type_cd
,t1.int_accr_start_dt as int_accr_start_dt
,t1.int_accr_end_dt as int_accr_end_dt
,t1.int_accr_accum as int_accr_accum
,t1.int_rat as int_rat
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,replace(replace(t1.erase_acct_flg,chr(13),''),chr(10),'') as erase_acct_flg
,replace(replace(t1.gl_post_flg,chr(13),''),chr(10),'') as gl_post_flg
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
from ${iml_schema}.evt_dep_pay_int_flow t1
where t1.etl_dt > add_months(to_date('${batch_date}','yyyymmdd') ,-3) and t1.etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_dep_pay_int_flow_q.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes