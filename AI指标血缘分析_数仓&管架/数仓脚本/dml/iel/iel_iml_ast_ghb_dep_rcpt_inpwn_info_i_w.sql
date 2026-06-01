: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_ghb_dep_rcpt_inpwn_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_ghb_dep_rcpt_inpwn_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.dep_rcpt_vouch_num,chr(13),''),chr(10),'') as dep_rcpt_vouch_num
,t.aval_amt as aval_amt
,replace(replace(t.cust_acct_num_id,chr(13),''),chr(10),'') as cust_acct_num_id
,t.effect_dt as effect_dt
,t.exp_dt as exp_dt
,t.acct_bal as acct_bal
,replace(replace(t.cust_sub_acct_num,chr(13),''),chr(10),'') as cust_sub_acct_num
,replace(replace(t.stop_pay_advise_id,chr(13),''),chr(10),'') as stop_pay_advise_id
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.dep_term_cd,chr(13),''),chr(10),'') as dep_term_cd
,t.int_rat as int_rat
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_ghb_dep_rcpt_inpwn_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes