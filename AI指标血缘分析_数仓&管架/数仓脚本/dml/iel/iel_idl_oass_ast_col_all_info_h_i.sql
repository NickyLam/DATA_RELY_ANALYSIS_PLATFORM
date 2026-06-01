: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_all_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_all_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.seq_num as seq_num
,t1.all_cust_id as all_cust_id
,t1.col_all_type_cd as col_all_type_cd
,t1.cert_type_cd as cert_type_cd
,t1.cert_no as cert_no
,t1.pmo_obg_brwer_rela_cd as pmo_obg_brwer_rela_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.col_belong_ps_trdpty_flg as col_belong_ps_trdpty_flg
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_all_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_all_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
