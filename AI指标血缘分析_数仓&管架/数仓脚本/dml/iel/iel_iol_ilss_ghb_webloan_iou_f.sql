: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_webloan_iou_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_webloan_iou.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.credit_no,chr(13),''),chr(10),'') as credit_no
,replace(replace(t.tax_no,chr(13),''),chr(10),'') as tax_no
,replace(replace(t.product_no,chr(13),''),chr(10),'') as product_no
,replace(replace(t.product_name,chr(13),''),chr(10),'') as product_name
,replace(replace(t.source,chr(13),''),chr(10),'') as source
,replace(replace(t.iou_no,chr(13),''),chr(10),'') as iou_no
,t.loan_amount as loan_amount
,replace(replace(t.loan_period_type,chr(13),''),chr(10),'') as loan_period_type
,t.loan_period as loan_period
,replace(replace(t.repay_date,chr(13),''),chr(10),'') as repay_date
,t.start_date as start_date
,t.end_date as end_date
,t.loan_rate as loan_rate
,t.base_profit_float as base_profit_float
,replace(replace(t.repay_method,chr(13),''),chr(10),'') as repay_method
,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
,t.base_rate as base_rate
,t.basis_point as basis_point
,t.principal_balance as principal_balance
,t.current_delay_days as current_delay_days
,replace(replace(t.manager_code,chr(13),''),chr(10),'') as manager_code
,replace(replace(t.branch_code,chr(13),''),chr(10),'') as branch_code
,replace(replace(t.acct_status,chr(13),''),chr(10),'') as acct_status
,replace(replace(t.branch_name,chr(13),''),chr(10),'') as branch_name
,t.etl_date as etl_date
from iol.ilss_ghb_webloan_iou t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_webloan_iou.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes