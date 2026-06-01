: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_rgst_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_rgst_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.rgst_seq_num as rgst_seq_num
,t1.rgst_org_name as rgst_org_name
,t1.rgst_val as rgst_val
,t1.rgst_dt as rgst_dt
,t1.rgst_exp_dt as rgst_exp_dt
,t1.pre_mtg_flg as pre_mtg_flg
,t1.pre_mtg_rgst_dt as pre_mtg_rgst_dt
,t1.pre_mtg_rgst_invalid_dt as pre_mtg_rgst_invalid_dt
,t1.operr_id as operr_id
,t1.rgst_cert_id as rgst_cert_id
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_rgst_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_rgst_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
