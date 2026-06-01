: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_rgst_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_rgst_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.rgst_seq_num as rgst_seq_num
,t.rgst_org_name as rgst_org_name
,t.rgst_val as rgst_val
,t.rgst_dt as rgst_dt
,t.rgst_exp_dt as rgst_exp_dt
,t.pre_mtg_flg as pre_mtg_flg
,t.pre_mtg_rgst_dt as pre_mtg_rgst_dt
,t.pre_mtg_rgst_invalid_dt as pre_mtg_rgst_invalid_dt
,t.operr_id as operr_id
,t.rgst_cert_id as rgst_cert_id
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark
,t.job_cd 
from ${idl_schema}.ast_col_rgst_info t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_rgst_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes