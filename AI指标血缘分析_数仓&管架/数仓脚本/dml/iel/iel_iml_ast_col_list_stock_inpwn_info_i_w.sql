: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_list_stock_inpwn_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_list_stock_inpwn_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.stock_cd,chr(13),''),chr(10),'') as stock_cd
,replace(replace(t.stock_name,chr(13),''),chr(10),'') as stock_name
,replace(replace(t.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t.issuer_brwer_flg,chr(13),''),chr(10),'') as issuer_brwer_flg
,t.corp_prev_year_margin as corp_prev_year_margin
,replace(replace(t.stock_nomal_flg,chr(13),''),chr(10),'') as stock_nomal_flg
,replace(replace(t.stock_status_cd,chr(13),''),chr(10),'') as stock_status_cd
,replace(replace(t.tran_site_cd,chr(13),''),chr(10),'') as tran_site_cd
,replace(replace(t.public_tran_flg,chr(13),''),chr(10),'') as public_tran_flg
,t.hold_shares_qtty as hold_shares_qtty
,t.inpwn_stock_qtty as inpwn_stock_qtty
,t.mk_pri as mk_pri
,t.last_year_share_divd_amt as last_year_share_divd_amt
,t.warning_line as warning_line
,t.per_share_net_asset as per_share_net_asset
,t.close_pos_line as close_pos_line
,t.inpwn_tot_val as inpwn_tot_val
,t.restr_exp_dt as restr_exp_dt
,replace(replace(t.other_comnt,chr(13),''),chr(10),'') as other_comnt
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.trust_broker_name,chr(13),''),chr(10),'') as trust_broker_name
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.ast_col_list_stock_inpwn_info t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_list_stock_inpwn_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes