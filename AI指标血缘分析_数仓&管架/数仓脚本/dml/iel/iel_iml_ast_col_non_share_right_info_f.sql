: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_non_share_right_info_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ast_col_non_share_right_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.pledge_share_corp_name,chr(13),''),chr(10),'') as pledge_share_corp_name
,replace(replace(t1.pledge_share_local_corp_cd,chr(13),''),chr(10),'') as pledge_share_local_corp_cd
,replace(replace(t1.issuer_brwer_flg,chr(13),''),chr(10),'') as issuer_brwer_flg
,hold_shares_qtty
,pledge_right_tot_right_ratio
,pledge_right_cnt
,per_share_mk_pri
,prev_share_divd_amt
,per_share_idtfy_val
,inpwn_tot_val
,per_share_net_asset
,warning_line
,close_pos_line
,net_asset_tot
,replace(replace(t1.descb,chr(13),''),chr(10),'') as descb
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,create_dt
,update_dt

from ${iml_schema}.ast_col_non_share_right_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_non_share_right_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
