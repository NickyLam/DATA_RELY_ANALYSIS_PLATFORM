: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_ghb_dep_rcpt_inpwn_info_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_ghb_dep_rcpt_inpwn_info.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.dep_rcpt_vouch_num as dep_rcpt_vouch_num
,t1.aval_amt as aval_amt
,t1.cust_acct_num_id as cust_acct_num_id
,t1.effect_dt as effect_dt
,t1.exp_dt as exp_dt
,t1.acct_bal as acct_bal
,t1.cust_sub_acct_num as cust_sub_acct_num
,t1.stop_pay_advise_id as stop_pay_advise_id
,t1.curr_cd as curr_cd
,t1.dep_term_cd as dep_term_cd
,t1.int_rat as int_rat
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.remark as remark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_ghb_dep_rcpt_inpwn_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
