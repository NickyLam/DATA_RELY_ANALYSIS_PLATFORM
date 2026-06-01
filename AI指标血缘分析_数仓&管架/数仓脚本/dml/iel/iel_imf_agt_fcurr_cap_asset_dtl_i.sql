: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_fcurr_cap_asset_dtl_i
CreateDate: 20230804
FileName:   ${iel_data_path}/agt_fcurr_cap_asset_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bal_dtl_id,chr(13),''),chr(10),'') as bal_dtl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.acct_b_id,chr(13),''),chr(10),'') as acct_b_id
,replace(replace(t1.entry_def_id,chr(13),''),chr(10),'') as entry_def_id
,replace(replace(t1.asset_cate_name,chr(13),''),chr(10),'') as asset_cate_name
,replace(replace(t1.bus_cate_name,chr(13),''),chr(10),'') as bus_cate_name
,replace(replace(t1.main_asset_id,chr(13),''),chr(10),'') as main_asset_id
,replace(replace(t1.minor_asset_id,chr(13),''),chr(10),'') as minor_asset_id
,bus_dt
,hold_pos
,hold_denom
,net_price_cost
,int_adj
,evha_val_chag
,int_cost
,full_price_cost
,impam_prep
,spd_prft
,amort_prft
,int_prft
,evha_val_chag_pl
,impam_loss
,tran_fee
,actl_int_rat
,comm_fee_inco
,comm_fee_expns
,value_dt
,exp_dt
,happ_amt
,amort_adj_fact
,replace(replace(t1.last_bal_dtl_id,chr(13),''),chr(10),'') as last_bal_dtl_id
,replace(replace(t1.offset_bal_dtl_id,chr(13),''),chr(10),'') as offset_bal_dtl_id
,replace(replace(t1.strk_bal_flg,chr(13),''),chr(10),'') as strk_bal_flg

from ${iml_schema}.agt_fcurr_cap_asset_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_fcurr_cap_asset_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
