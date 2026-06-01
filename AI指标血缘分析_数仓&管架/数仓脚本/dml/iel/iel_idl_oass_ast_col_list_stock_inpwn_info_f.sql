: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_list_stock_inpwn_info_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_ast_col_list_stock_inpwn_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.stock_cd as stock_cd
,t1.stock_name as stock_name
,t1.corp_name as corp_name
,t1.issuer_brwer_flg as issuer_brwer_flg
,t1.corp_prev_year_margin as corp_prev_year_margin
,t1.stock_nomal_flg as stock_nomal_flg
,t1.stock_status_cd as stock_status_cd
,t1.tran_site_cd as tran_site_cd
,t1.public_tran_flg as public_tran_flg
,t1.hold_shares_qtty as hold_shares_qtty
,t1.inpwn_stock_qtty as inpwn_stock_qtty
,t1.mk_pri as mk_pri
,t1.last_year_share_divd_amt as last_year_share_divd_amt
,t1.warning_line as warning_line
,t1.per_share_net_asset as per_share_net_asset
,t1.close_pos_line as close_pos_line
,t1.inpwn_tot_val as inpwn_tot_val
,t1.restr_exp_dt as restr_exp_dt
,t1.other_comnt as other_comnt
,t1.curr_cd as curr_cd
,t1.trust_broker_name as trust_broker_name
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_list_stock_inpwn_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_list_stock_inpwn_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
