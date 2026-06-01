: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_insure_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_insure_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.insure_seq_num as insure_seq_num
,t.insure_pl_id as insure_pl_id
,t.insu_comp_name as insu_comp_name
,t.insu_comp_orgnz_cd as insu_comp_orgnz_cd
,t.full_amt_insure_flg as full_amt_insure_flg
,t.insure_insud_amt as insure_insud_amt
,t.begin_dt as begin_dt
,t.exp_dt as exp_dt
,t.check_guar_dt as check_guar_dt
,t.fst_ctfer_name as fst_ctfer_name
,t.secd_ctfer_name as secd_ctfer_name
,t.operr_id as operr_id
,t.insure_status_cd as insure_status_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_col_insure_info t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_insure_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes