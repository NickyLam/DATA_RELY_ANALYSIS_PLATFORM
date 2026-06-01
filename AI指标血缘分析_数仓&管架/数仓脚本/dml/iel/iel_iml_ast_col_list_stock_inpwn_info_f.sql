: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_list_stock_inpwn_info_f
CreateDate: 20230919
FileName:   ${iel_data_path}/ast_col_list_stock_inpwn_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.stock_cd,chr(13),''),chr(10),'') as stock_cd
,replace(replace(t1.stock_name,chr(13),''),chr(10),'') as stock_name
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.issuer_brwer_flg,chr(13),''),chr(10),'') as issuer_brwer_flg
,corp_prev_year_margin
,replace(replace(t1.stock_nomal_flg,chr(13),''),chr(10),'') as stock_nomal_flg
,replace(replace(t1.stock_status_cd,chr(13),''),chr(10),'') as stock_status_cd
,replace(replace(t1.tran_site_cd,chr(13),''),chr(10),'') as tran_site_cd
,replace(replace(t1.public_tran_flg,chr(13),''),chr(10),'') as public_tran_flg
,hold_shares_qtty
,inpwn_stock_qtty
,mk_pri
,last_year_share_divd_amt
,warning_line
,per_share_net_asset
,close_pos_line
,inpwn_tot_val
,restr_exp_dt
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.trust_broker_name,chr(13),''),chr(10),'') as trust_broker_name

from ${iml_schema}.ast_col_list_stock_inpwn_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_list_stock_inpwn_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
