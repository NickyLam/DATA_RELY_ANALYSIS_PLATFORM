: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_obank_dep_rcpt_inpwn_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_obank_dep_rcpt_inpwn_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.vouch_id as vouch_id
,t1.aval_amt as aval_amt
,t1.bank_name as bank_name
,t1.bank_rgst_cd as bank_rgst_cd
,t1.ext_rating_dt as ext_rating_dt
,t1.ext_rating_rest_cd as ext_rating_rest_cd
,t1.effect_dt as effect_dt
,t1.exp_dt as exp_dt
,t1.dep_term as dep_term
,t1.int_rat as int_rat
,t1.pric_amt as pric_amt
,t1.curr_cd as curr_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.remark as remark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_obank_dep_rcpt_inpwn_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_obank_dep_rcpt_inpwn_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
