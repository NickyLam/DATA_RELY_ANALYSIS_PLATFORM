: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_wl_loan_iou_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_wl_loan_iou.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.loan_id as loan_id
,t.apply_id as apply_id
,replace(replace(t.iou_no,chr(13),''),chr(10),'') as iou_no
,t.contract_id as contract_id
,t.loan_amount as loan_amount
,replace(replace(t.loan_period_type,chr(13),''),chr(10),'') as loan_period_type
,t.loan_period as loan_period
,replace(replace(t.repay_date,chr(13),''),chr(10),'') as repay_date
,t.start_date as start_date
,t.end_date as end_date
,t.loan_rate as loan_rate
,t.loan_month_rate as loan_month_rate
,t.base_profit_float as base_profit_float
,replace(replace(t.repay_method,chr(13),''),chr(10),'') as repay_method
,t.create_user as create_user
,t.create_time as create_time
,t.update_user as update_user
,t.update_time as update_time
,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t.project_no,chr(13),''),chr(10),'') as project_no
,replace(replace(t.merchant_no,chr(13),''),chr(10),'') as merchant_no
,replace(replace(t.prod_rate_no,chr(13),''),chr(10),'') as prod_rate_no
,t.base_rate as base_rate
,t.basis_point as basis_point
,replace(replace(t.agency_no,chr(13),''),chr(10),'') as agency_no
,replace(replace(t.compen_mode,chr(13),''),chr(10),'') as compen_mode
,replace(replace(t.nfis_mode,chr(13),''),chr(10),'') as nfis_mode
,replace(replace(t.repay_acct_no,chr(13),''),chr(10),'') as repay_acct_no
,t.refinance_flg as refinance_flg
,t.combined_flg as combined_flg
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ilss_wl_loan_iou t
where start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_wl_loan_iou.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes