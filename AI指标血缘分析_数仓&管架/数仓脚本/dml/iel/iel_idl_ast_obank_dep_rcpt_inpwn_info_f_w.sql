: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_obank_dep_rcpt_inpwn_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_obank_dep_rcpt_inpwn_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.vouch_id as vouch_id
,t.aval_amt as aval_amt
,t.bank_name as bank_name
,t.bank_rgst_cd as bank_rgst_cd
,t.ext_rating_dt as ext_rating_dt
,t.ext_rating_rest_cd as ext_rating_rest_cd
,t.effect_dt as effect_dt
,t.exp_dt as exp_dt
,t.dep_term as dep_term
,t.int_rat as int_rat
,t.pric_amt as pric_amt
,t.curr_cd as curr_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_obank_dep_rcpt_inpwn_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_obank_dep_rcpt_inpwn_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes