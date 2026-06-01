: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_dc_cap_asset_bal_chg_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_dc_cap_asset_bal_chg_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bal_chg_dtl_id,chr(13),''),chr(10),'') as bal_chg_dtl_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.bus_tab_name,chr(13),''),chr(10),'') as bus_tab_name
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.acct_b_id,chr(13),''),chr(10),'') as acct_b_id
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name
,replace(replace(t1.bus_cate_name,chr(13),''),chr(10),'') as bus_cate_name
,replace(replace(t1.main_asset_id,chr(13),''),chr(10),'') as main_asset_id
,replace(replace(t1.minor_asset_id,chr(13),''),chr(10),'') as minor_asset_id
,t1.actl_acpt_pay_dt as actl_acpt_pay_dt
,t1.hold_pos as hold_pos
,t1.hold_denom as hold_denom
,t1.net_price_cost as net_price_cost
,t1.int_adj as int_adj
,t1.evha_val_chag as evha_val_chag
,t1.int_cost as int_cost
,t1.full_price_cost as full_price_cost
,t1.impam_prep as impam_prep
,t1.spd_prft as spd_prft
,t1.amort_prft as amort_prft
,t1.int_prft as int_prft
,t1.evha_val_chag_pl as evha_val_chag_pl
,t1.impam_loss as impam_loss
,t1.tran_fee as tran_fee
,t1.actl_int_rat as actl_int_rat
,t1.value_dt as value_dt
,t1.exp_dt as exp_dt
,t1.final_update_tm as final_update_tm
,t1.happ_amt as happ_amt
,replace(replace(t1.last_bal_chg_dtl_id,chr(13),''),chr(10),'') as last_bal_chg_dtl_id
,replace(replace(t1.strk_bal_flg,chr(13),''),chr(10),'') as strk_bal_flg
,t1.comm_fee_inco as comm_fee_inco
,t1.comm_fee_expns as comm_fee_expns
from ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_dc_cap_asset_bal_chg_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes