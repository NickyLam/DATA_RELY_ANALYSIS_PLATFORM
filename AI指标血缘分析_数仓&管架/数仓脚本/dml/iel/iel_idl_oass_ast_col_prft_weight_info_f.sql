: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_prft_weight_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_prft_weight_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.prft_weight_gover_doc_id as prft_weight_gover_doc_id
,t1.prft_weight_gover_doc_name as prft_weight_gover_doc_name
,t1.eqty_cert_id as eqty_cert_id
,t1.eqty_owner_name as eqty_owner_name
,t1.eqty_start_dt as eqty_start_dt
,t1.eqty_exp_dt as eqty_exp_dt
,t1.other_comnt as other_comnt
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_prft_weight_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_prft_weight_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
