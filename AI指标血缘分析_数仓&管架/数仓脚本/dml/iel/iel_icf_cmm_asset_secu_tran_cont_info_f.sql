: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_asset_secu_tran_cont_info_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_asset_secu_tran_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.asset_pool_id,chr(13),''),chr(10),'') as asset_pool_id
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd
,replace(replace(t1.prod_bus_status_cd,chr(13),''),chr(10),'') as prod_bus_status_cd
,replace(replace(t1.prod_mode_cd,chr(13),''),chr(10),'') as prod_mode_cd
,replace(replace(t1.asset_pool_type_cd,chr(13),''),chr(10),'') as asset_pool_type_cd
,replace(replace(t1.asset_pool_char_cd,chr(13),''),chr(10),'') as asset_pool_char_cd
,replace(replace(t1.asset_pool_status_cd,chr(13),''),chr(10),'') as asset_pool_status_cd
,replace(replace(t1.tran_calc_way_cd,chr(13),''),chr(10),'') as tran_calc_way_cd
,replace(replace(t1.cntpty_org_type_cd,chr(13),''),chr(10),'') as cntpty_org_type_cd
,replace(replace(t1.pay_dt_rule_cd,chr(13),''),chr(10),'') as pay_dt_rule_cd
,replace(replace(t1.ts_cd,chr(13),''),chr(10),'') as ts_cd
,replace(replace(t1.user_def_coll_ped_flg,chr(13),''),chr(10),'') as user_def_coll_ped_flg
,replace(replace(t1.clearup_repo_flg,chr(13),''),chr(10),'') as clearup_repo_flg
,replace(replace(t1.tran_plat_name,chr(13),''),chr(10),'') as tran_plat_name
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,pkg_dt
,begin_dt
,exp_dt
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,asset_tot_amt
,issue_tot_amt
,asset_tran_consideration_amt
,asset_tran_comm_fee
,prod_self_hold_amt
,replace(replace(t1.issue_qtty,chr(13),''),chr(10),'') as issue_qtty
,bank_rgst_center_amt
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.cntpty_acct_num,chr(13),''),chr(10),'') as cntpty_acct_num
,replace(replace(t1.cntpty_open_bank_name,chr(13),''),chr(10),'') as cntpty_open_bank_name
,cntpty_tran_dt
,cntpty_pay_amt
,replace(replace(t1.non_asset_flg,chr(13),''),chr(10),'') as non_asset_flg

from ${icl_schema}.cmm_asset_secu_tran_cont_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_asset_secu_tran_cont_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
