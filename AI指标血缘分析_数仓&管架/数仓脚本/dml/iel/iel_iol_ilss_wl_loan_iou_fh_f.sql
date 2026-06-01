: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_wl_loan_iou_fh_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_wl_loan_iou_fh.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.iou_id as iou_id
,t.loan_amount as loan_amount
,t.normal_principal as normal_principal
,t.delay_principal as delay_principal
,t.sluggish_principal as sluggish_principal
,t.debts_principal as debts_principal
,t.principal_balance as principal_balance
,t.interest_in_loan as interest_in_loan
,t.interest_delay_in_loan as interest_delay_in_loan
,t.interest_in_the_interest as interest_in_the_interest
,t.interest_other_in_loan as interest_other_in_loan
,t.interest_out_loan as interest_out_loan
,t.interest_delay_out_loan as interest_delay_out_loan
,t.interest_out_the_interest as interest_out_the_interest
,t.interest_other_out_loan as interest_other_out_loan
,t.count_interest_loan as count_interest_loan
,t.count_interest_delay as count_interest_delay
,t.count_interest_in_interest as count_interest_in_interest
,t.count_interest_other as count_interest_other
,t.count_interest_in as count_interest_in
,t.count_interest_out as count_interest_out
,t.receivable_service_fee as receivable_service_fee
,t.receivable_poundage as receivable_poundage
,t.receivable_other_fee as receivable_other_fee
,t.owed_service_fee as owed_service_fee
,t.owed_poundage as owed_poundage
,t.owed_other_fee as owed_other_fee
,t.count_service_fee as count_service_fee
,t.count_poundage as count_poundage
,t.count_other_fee as count_other_fee
,t.month_rate as month_rate
,t.delay_month_rate as delay_month_rate
,t.compound_interest_month_rate as compound_interest_month_rate
,t.other_month_rate as other_month_rate
,t.service_rate as service_rate
,t.poundage_rate as poundage_rate
,t.other_fee_rate as other_fee_rate
,t.principal_product as principal_product
,t.in_product as in_product
,t.out_product as out_product
,t.compound_interest_product as compound_interest_product
,t.extension_flg as extension_flg
,replace(replace(t.extension_no,chr(13),''),chr(10),'') as extension_no
,t.write_off_flg as write_off_flg
,replace(replace(t.write_off_no,chr(13),''),chr(10),'') as write_off_no
,t.first_delay_date as first_delay_date
,t.last_delay_date as last_delay_date
,t.current_delay_days as current_delay_days
,t.count_delay_days as count_delay_days
,t.longest_delay_days as longest_delay_days
,t.count_delay_term as count_delay_term
,t.longest_continue_delay_term as longest_continue_delay_term
,t.iou_delay_flg as iou_delay_flg
,replace(replace(t.four_catalog,chr(13),''),chr(10),'') as four_catalog
,replace(replace(t.five_catalog,chr(13),''),chr(10),'') as five_catalog
,replace(replace(t.ten_catalog,chr(13),''),chr(10),'') as ten_catalog
,replace(replace(t.twelve_catalog,chr(13),''),chr(10),'') as twelve_catalog
,replace(replace(t.create_user,chr(13),''),chr(10),'') as create_user
,t.create_time as create_time
,replace(replace(t.update_user,chr(13),''),chr(10),'') as update_user
,t.update_time as update_time
,t.acct_status as acct_status
,replace(replace(t.loan_account,chr(13),''),chr(10),'') as loan_account
,replace(replace(t.iou_no,chr(13),''),chr(10),'') as iou_no
,replace(replace(t.product_no,chr(13),''),chr(10),'') as product_no
,t.group_id as group_id
,replace(replace(t.branch_code,chr(13),''),chr(10),'') as branch_code
,t.raccr_int as raccr_int
,t.obs_cal_int as obs_cal_int
,t.raccr_arr_int as raccr_arr_int
,t.obdebt_int as obdebt_int
,t.raccr_pnty_int as raccr_pnty_int
,t.obs_pun_int as obs_pun_int
,t.rcbl_pnty_int as rcbl_pnty_int
,t.obpnsh_int as obpnsh_int
,t.accr_comp_int as accr_comp_int
,t.settle_date as settle_date
,t.curr_dlay_date as curr_dlay_date
,t.curr_dlay_start_term as curr_dlay_start_term
,replace(replace(t.gprd_due_date,chr(13),''),chr(10),'') as gprd_due_date
,t.gprd_days as gprd_days
,replace(replace(t.gprd_bgn_date,chr(13),''),chr(10),'') as gprd_bgn_date
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ilss_wl_loan_iou_fh t
where start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_wl_loan_iou_fh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes