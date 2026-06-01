: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ifrs_val_rpt_trade_i
CreateDate: 20221115
FileName:   ${iel_data_path}/ifrs_val_rpt_trade.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,d_data_dt
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
,n_balance
,n_actual_pay
,n_accrual_interest
,n_pv
,n_pv_variation
,n_duration
,n_time_to_mat
,n_time_to_repricing
,replace(replace(t1.v_trade_system,chr(13),''),chr(10),'') as v_trade_system
,d_putoutdate
,d_maturity
,n_businessrate
,replace(replace(t1.v_value_model,chr(13),''),chr(10),'') as v_value_model
,replace(replace(t1.v_subjectno,chr(13),''),chr(10),'') as v_subjectno
,n_valid
,replace(replace(t1.v_classifyresult,chr(13),''),chr(10),'') as v_classifyresult
,replace(replace(t1.v_trade_no,chr(13),''),chr(10),'') as v_trade_no
,n_pv_lastday
,n_pv_acctday
,n_pv_move_p_lastday
,n_pv_move_p_acctday
,replace(replace(t1.v_operate_orgid,chr(13),''),chr(10),'') as v_operate_orgid
,replace(replace(t1.v_bill_no,chr(13),''),chr(10),'') as v_bill_no
,n_interest_adjust
,n_zspread
,replace(replace(t1.v_interest_period,chr(13),''),chr(10),'') as v_interest_period
,replace(replace(t1.v_counterparty_name,chr(13),''),chr(10),'') as v_counterparty_name
,n_pvcny_variation
,replace(replace(t1.v_dept_id,chr(13),''),chr(10),'') as v_dept_id
,replace(replace(t1.v_subject_name,chr(13),''),chr(10),'') as v_subject_name
,n_position_value
,n_account_value
,n_net_pv
,n_base_point_value
,n_convexity
,n_interest_accrued
,replace(replace(t1.v_serialno,chr(13),''),chr(10),'') as v_serialno
,replace(replace(t1.v_three_stage_cd,chr(13),''),chr(10),'') as v_three_stage_cd
,replace(replace(t1.v_produck_type_s_cd,chr(13),''),chr(10),'') as v_produck_type_s_cd
,replace(replace(t1.v_cust_code,chr(13),''),chr(10),'') as v_cust_code
,n_dirtyprice
,n_cleanprice
,v_bondduration
,v_bonddv01
,v_bondconvexity
,replace(replace(t1.v_bond_rating,chr(13),''),chr(10),'') as v_bond_rating
,replace(replace(t1.v_overdue_flag,chr(13),''),chr(10),'') as v_overdue_flag
,n_par_rate
,replace(replace(t1.v_gzmeth,chr(13),''),chr(10),'') as v_gzmeth
,replace(replace(t1.v_asset_code,chr(13),''),chr(10),'') as v_asset_code
,replace(replace(t1.v_asset_name,chr(13),''),chr(10),'') as v_asset_name
,n_pv_full_price
,n_pv_lastday_dif
,n_pv_lastmon_dif
,n_pv_lastyear_dif
,n_pv_variation_dif
,replace(replace(t1.v_bond_name,chr(13),''),chr(10),'') as v_bond_name
,replace(replace(t1.v_bond_cd,chr(13),''),chr(10),'') as v_bond_cd
,n_face_value_bal
,n_netvalue
,n_holding_share
,replace(replace(t1.v_fund_name,chr(13),''),chr(10),'') as v_fund_name
,replace(replace(t1.v_fund_no,chr(13),''),chr(10),'') as v_fund_no
,n_accrued_interest
,replace(replace(t1.v_trade_name,chr(13),''),chr(10),'') as v_trade_name
,n_cleancost
,n_cost
,replace(replace(t1.v_trade_type,chr(13),''),chr(10),'') as v_trade_type
,n_ovdue_cost
,n_pvcny
,n_curr_convt_rate
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,n_accrued_interest_ext
,n_accrual_interest_ext
,replace(replace(t1.bill_no,chr(13),''),chr(10),'') as bill_no
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,replace(replace(t1.glob_seq_num,chr(13),''),chr(10),'') as glob_seq_num
,replace(replace(t1.unique_seq_num,chr(13),''),chr(10),'') as unique_seq_num

from ${iol_schema}.ifrs_val_rpt_trade t1
where d_data_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifrs_val_rpt_trade.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
