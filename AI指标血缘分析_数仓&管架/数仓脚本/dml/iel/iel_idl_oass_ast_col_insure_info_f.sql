: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_insure_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_insure_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.insure_seq_num as insure_seq_num
,t1.insure_pl_id as insure_pl_id
,t1.insu_comp_name as insu_comp_name
,t1.insu_comp_orgnz_cd as insu_comp_orgnz_cd
,t1.full_amt_insure_flg as full_amt_insure_flg
,t1.insure_insud_amt as insure_insud_amt
,t1.begin_dt as begin_dt
,t1.exp_dt as exp_dt
,t1.check_guar_dt as check_guar_dt
,t1.fst_ctfer_name as fst_ctfer_name
,t1.secd_ctfer_name as secd_ctfer_name
,t1.operr_id as operr_id
,t1.insure_status_cd as insure_status_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_insure_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_insure_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
