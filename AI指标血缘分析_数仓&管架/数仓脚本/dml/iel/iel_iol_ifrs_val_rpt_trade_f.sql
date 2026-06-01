: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifrs_val_rpt_trade_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ifrs_val_rpt_trade.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.d_data_dt as d_data_dt
,replace(replace(t1.v_contract_no,chr(13),''),chr(10),'') as v_contract_no
,replace(replace(t1.v_businesstype,chr(13),''),chr(10),'') as v_businesstype
,replace(replace(t1.v_businesssubtype,chr(13),''),chr(10),'') as v_businesssubtype
,replace(replace(t1.v_currency_code,chr(13),''),chr(10),'') as v_currency_code
,replace(replace(t1.v_org_id,chr(13),''),chr(10),'') as v_org_id
,replace(replace(t1.v_three_class,chr(13),''),chr(10),'') as v_three_class
,replace(replace(t1.n_fv_tier,chr(13),''),chr(10),'') as n_fv_tier
,replace(replace(t1.v_asset_type,chr(13),''),chr(10),'') as v_asset_type
,replace(replace(t1.v_value_type,chr(13),''),chr(10),'') as v_value_type
,replace(replace(t1.v_targetasset_ind,chr(13),''),chr(10),'') as v_targetasset_ind
,replace(replace(t1.v_layer,chr(13),''),chr(10),'') as v_layer
,t1.n_balance as n_balance
,t1.n_actual_pay as n_actual_pay
,t1.n_accrual_interest as n_accrual_interest
,t1.n_pv as n_pv
,t1.n_pv_variation as n_pv_variation
,t1.n_duration as n_duration
,t1.n_time_to_mat as n_time_to_mat
,t1.n_time_to_repricing as n_time_to_repricing
,replace(replace(t1.v_trade_system,chr(13),''),chr(10),'') as v_trade_system
,t1.d_putoutdate as d_putoutdate
,t1.d_maturity as d_maturity
,t1.n_businessrate as n_businessrate
,replace(replace(t1.v_value_model,chr(13),''),chr(10),'') as v_value_model
,replace(replace(t1.v_subjectno,chr(13),''),chr(10),'') as v_subjectno
,t1.n_valid as n_valid
,replace(replace(t1.v_classifyresult,chr(13),''),chr(10),'') as v_classifyresult
,replace(replace(t1.v_trade_no,chr(13),''),chr(10),'') as v_trade_no
,t1.n_pv_lastday as n_pv_lastday
,t1.n_pv_acctday as n_pv_acctday
,t1.n_pv_move_p_lastday as n_pv_move_p_lastday
,t1.n_pv_move_p_acctday as n_pv_move_p_acctday
,replace(replace(t1.v_operate_orgid,chr(13),''),chr(10),'') as v_operate_orgid
,replace(replace(t1.v_bill_no,chr(13),''),chr(10),'') as v_bill_no
,t1.n_interest_adjust as n_interest_adjust
,t1.n_zspread as n_zspread
,replace(replace(t1.v_interest_period,chr(13),''),chr(10),'') as v_interest_period
,replace(replace(t1.v_counterparty_name,chr(13),''),chr(10),'') as v_counterparty_name
,t1.n_pvcny_variation as n_pvcny_variation
,replace(replace(t1.v_dept_id,chr(13),''),chr(10),'') as v_dept_id
,replace(replace(t1.v_subject_name,chr(13),''),chr(10),'') as v_subject_name
,t1.n_position_value as n_position_value
,t1.n_account_value as n_account_value
,t1.n_net_pv as n_net_pv
,t1.n_base_point_value as n_base_point_value
,t1.n_convexity as n_convexity
,t1.n_interest_accrued as n_interest_accrued
,replace(replace(t1.v_serialno,chr(13),''),chr(10),'') as v_serialno
,replace(replace(t1.v_three_stage_cd,chr(13),''),chr(10),'') as v_three_stage_cd
,replace(replace(t1.v_produck_type_s_cd,chr(13),''),chr(10),'') as v_produck_type_s_cd
,replace(replace(t1.v_cust_code,chr(13),''),chr(10),'') as v_cust_code
,t1.n_dirtyprice as n_dirtyprice
,t1.n_cleanprice as n_cleanprice
,t1.v_bondduration as v_bondduration
,t1.v_bonddv01 as v_bonddv01
,t1.v_bondconvexity as v_bondconvexity
,replace(replace(t1.v_bond_rating,chr(13),''),chr(10),'') as v_bond_rating
,replace(replace(t1.v_overdue_flag,chr(13),''),chr(10),'') as v_overdue_flag
,t1.n_par_rate as n_par_rate
,replace(replace(t1.v_gzmeth,chr(13),''),chr(10),'') as v_gzmeth
,replace(replace(t1.v_asset_code,chr(13),''),chr(10),'') as v_asset_code
,replace(replace(t1.v_asset_name,chr(13),''),chr(10),'') as v_asset_name
,t1.n_pv_full_price as n_pv_full_price
,t1.n_pv_lastday_dif as n_pv_lastday_dif
,t1.n_pv_lastmon_dif as n_pv_lastmon_dif
,t1.n_pv_lastyear_dif as n_pv_lastyear_dif
,t1.n_pv_variation_dif as n_pv_variation_dif
,replace(replace(t1.v_bond_name,chr(13),''),chr(10),'') as v_bond_name
,replace(replace(t1.v_bond_cd,chr(13),''),chr(10),'') as v_bond_cd
,t1.n_face_value_bal as n_face_value_bal
,t1.n_netvalue as n_netvalue
,t1.n_holding_share as n_holding_share
,replace(replace(t1.v_fund_name,chr(13),''),chr(10),'') as v_fund_name
,replace(replace(t1.v_fund_no,chr(13),''),chr(10),'') as v_fund_no
,t1.n_accrued_interest as n_accrued_interest
,replace(replace(t1.v_trade_name,chr(13),''),chr(10),'') as v_trade_name
,t1.n_cleancost as n_cleancost
,t1.n_cost as n_cost
,replace(replace(t1.v_trade_type,chr(13),''),chr(10),'') as v_trade_type
,t1.n_ovdue_cost as n_ovdue_cost
,t1.n_pvcny as n_pvcny
,t1.n_curr_convt_rate as n_curr_convt_rate
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,t1.n_accrued_interest_ext as n_accrued_interest_ext
,t1.n_accrual_interest_ext as n_accrual_interest_ext
,replace(replace(t1.bill_no,chr(13),''),chr(10),'') as bill_no
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,replace(replace(t1.glob_seq_num,chr(13),''),chr(10),'') as glob_seq_num
,replace(replace(t1.unique_seq_num,chr(13),''),chr(10),'') as unique_seq_num
from ${iol_schema}.ifrs_val_rpt_trade t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifrs_val_rpt_trade.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes