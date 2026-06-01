: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_asset_pool_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_asset_pool_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.asset_pool_id,chr(13),''),chr(10),'') as asset_pool_id
,replace(replace(t1.asset_pool_name,chr(13),''),chr(10),'') as asset_pool_name
,replace(replace(t1.parent_asset_pool_id,chr(13),''),chr(10),'') as parent_asset_pool_id
,replace(replace(t1.asset_pool_type_cd,chr(13),''),chr(10),'') as asset_pool_type_cd
,replace(replace(t1.asset_pool_char_cd,chr(13),''),chr(10),'') as asset_pool_char_cd
,replace(replace(t1.asset_pool_status_cd,chr(13),''),chr(10),'') as asset_pool_status_cd
,replace(replace(t1.pkg_flg,chr(13),''),chr(10),'') as pkg_flg
,t1.pkg_dt as pkg_dt
,t1.tran_dt as tran_dt
,t1.recvbl_dt as recvbl_dt
,t1.pkg_day_asset_qtty as pkg_day_asset_qtty
,t1.pkg_day_asset_size as pkg_day_asset_size
,t1.tran_day_pric as tran_day_pric
,t1.recvbl_day_pric as recvbl_day_pric
,t1.actl_recvbl_amt as actl_recvbl_amt
,t1.asset_pool_size as asset_pool_size
,t1.unpkg_dt as unpkg_dt
,replace(replace(t1.end_type_cd,chr(13),''),chr(10),'') as end_type_cd
,t1.final_dt as final_dt
,t1.add_pkg_asset_qtty as add_pkg_asset_qtty
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,t1.rgst_tm as rgst_tm
,t1.asset_pool_acm_asset_size as asset_pool_acm_asset_size
,t1.asset_pool_acm_asset_qtty as asset_pool_acm_asset_qtty
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_acct_belong_org_id,chr(13),''),chr(10),'') as recvbl_acct_belong_org_id
,replace(replace(t1.return_coll_acct_name,chr(13),''),chr(10),'') as return_coll_acct_name
,replace(replace(t1.return_coll_acct_num,chr(13),''),chr(10),'') as return_coll_acct_num
,replace(replace(t1.coll_acct_belong_org_id,chr(13),''),chr(10),'') as coll_acct_belong_org_id
,t1.pkg_weight_surp_tenor as pkg_weight_surp_tenor
,t1.pkg_weight_avg_int_rat as pkg_weight_avg_int_rat
,t1.fee_provi_dt as fee_provi_dt
,t1.asset_pool_realtm_size as asset_pool_realtm_size
,t1.update_tm as update_tm
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_asset_pool_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_asset_pool_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes