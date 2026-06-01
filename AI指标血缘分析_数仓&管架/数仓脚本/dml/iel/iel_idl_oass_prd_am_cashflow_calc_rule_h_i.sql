: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_prd_am_cashflow_calc_rule_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_prd_am_cashflow_calc_rule_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.effect_dt as effect_dt
,t1.accti_type_cd as accti_type_cd
,t1.base_type_cd as base_type_cd
,t1.base_dt_type_cd as base_dt_type_cd
,t1.int_accr_base_cd as int_accr_base_cd
,t1.int_rat as int_rat
,t1.init_int_rat_flg as init_int_rat_flg
,t1.prod_id as prod_id
,t1.src_prod_id as src_prod_id
,t1.brch_seq_num as brch_seq_num
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.cashflow_id as cashflow_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_prd_am_cashflow_calc_rule_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_prd_am_cashflow_calc_rule_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
