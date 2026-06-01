: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_rpt_adm_loan_detail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_rpt_adm_loan_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.data_dt as data_dt
,replace(replace(t.iou_no,chr(13),''),chr(10),'') as iou_no
,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t.apply_no,chr(13),''),chr(10),'') as apply_no
,replace(replace(t.decision_no,chr(13),''),chr(10),'') as decision_no
,replace(replace(t.state,chr(13),''),chr(10),'') as state
,t.quota as quota
,replace(replace(t.name,chr(13),''),chr(10),'') as name
,replace(replace(t.id_type,chr(13),''),chr(10),'') as id_type
,replace(replace(t.id_no,chr(13),''),chr(10),'') as id_no
,replace(replace(t.sex,chr(13),''),chr(10),'') as sex
,t.age as age
,replace(replace(t.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t.marriage,chr(13),''),chr(10),'') as marriage
,replace(replace(t.education,chr(13),''),chr(10),'') as education
,replace(replace(t.company_name,chr(13),''),chr(10),'') as company_name
,replace(replace(t.house_hold,chr(13),''),chr(10),'') as house_hold
,replace(replace(t.drive_type,chr(13),''),chr(10),'') as drive_type
,replace(replace(t.home_perv,chr(13),''),chr(10),'') as home_perv
,replace(replace(t.home_city,chr(13),''),chr(10),'') as home_city
,replace(replace(t.home_address,chr(13),''),chr(10),'') as home_address
,t.trans_amount as trans_amount
,t.trans_time as trans_time
,replace(replace(t.loan_foward,chr(13),''),chr(10),'') as loan_foward
,t.loan_period as loan_period
,replace(replace(t.repay_method,chr(13),''),chr(10),'') as repay_method
,t.start_date as start_date
,t.end_date as end_date
,t.loan_rate as loan_rate
,t.loan_balance as loan_balance
,replace(replace(t.five_catalog,chr(13),''),chr(10),'') as five_catalog
,replace(replace(t.guar_type,chr(13),''),chr(10),'') as guar_type
,t.extend_days as extend_days
,replace(replace(t.cap_overdue_date,chr(13),''),chr(10),'') as cap_overdue_date
,replace(replace(t.int_overdue_date,chr(13),''),chr(10),'') as int_overdue_date
,t.current_delay_days as current_delay_days
,replace(replace(t.first_delay_date,chr(13),''),chr(10),'') as first_delay_date
,replace(replace(t.settl_date,chr(13),''),chr(10),'') as settl_date
,replace(replace(t.repay_date,chr(13),''),chr(10),'') as repay_date
,t.accr_pay_bal as accr_pay_bal
,t.accr_corpam as accr_corpam
,t.accr_instam as accr_instam
,t.accr_over_duebal as accr_over_duebal
,t.accr_overdue_int as accr_overdue_int
,t.accr_pnty_int as accr_pnty_int
,t.accr_rece_int as accr_rece_int
,t.pay_bal as pay_bal
,t.unpd_bal as unpd_bal
,t.over_due_bal as over_due_bal
,t.over_arr_bal as over_arr_bal
,t.over_pnt_bal as over_pnt_bal
,t.over_rece_bal as over_rece_bal
,t.r_amt as r_amt
,t.r_captial as r_captial
,t.r_accrual as r_accrual
,t.r_pntyint_amt as r_pntyint_amt
,t.r_retint_amt as r_retint_amt
,replace(replace(t.pay_bank_card_no,chr(13),''),chr(10),'') as pay_bank_card_no
,t.iou_delay_flg as iou_delay_flg
,t.last_delay_date as last_delay_date
,t.count_delay_days as count_delay_days
,t.dpdx as dpdx
,t.dpd30 as dpd30
,replace(replace(t.repay_dt,chr(13),''),chr(10),'') as repay_dt
,replace(replace(t.account_statusc,chr(13),''),chr(10),'') as account_statusc
,t.product_id as product_id
,replace(replace(t.ten_catalog,chr(13),''),chr(10),'') as ten_catalog
,replace(replace(t.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t.finish_date,chr(13),''),chr(10),'') as finish_date
,t.raccr_int as raccr_int
,t.recon_amt as recon_amt
,t.recon_int as recon_int
,t.rcbl_chgr as rcbl_chgr
,t.rec_bal as rec_bal
,t.rec_int as rec_int
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ilss_rpt_adm_loan_detail t
where start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_rpt_adm_loan_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes