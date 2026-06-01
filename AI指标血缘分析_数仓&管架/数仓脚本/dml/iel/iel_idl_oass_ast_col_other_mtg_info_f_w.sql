: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_other_mtg_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/oass_ast_col_other_mtg_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.asset_id
,t.lp_id
,t.col_name
,t.col_qtty
,t.measure_corp_cd
,t.col_val
,t.col_store_addr
,t.prop_get_dt
,t.col_ori_price_val
,t.other_comnt
,t.curr_cd
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.oass_ast_col_other_mtg_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_other_mtg_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes