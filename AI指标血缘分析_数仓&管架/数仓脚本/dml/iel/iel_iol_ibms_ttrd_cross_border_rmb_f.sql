: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_cross_border_rmb_f
CreateDate: 20241015
FileName:   ${iel_data_path}/ibms_ttrd_cross_border_rmb.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.accid,chr(13),''),chr(10),'') as accid
,replace(replace(t1.accname,chr(13),''),chr(10),'') as accname
,replace(replace(t1.exhacc,chr(13),''),chr(10),'') as exhacc
,replace(replace(t1.customer_id,chr(13),''),chr(10),'') as customer_id
,replace(replace(t1.customer_name,chr(13),''),chr(10),'') as customer_name
,replace(replace(t1.start_date,chr(13),''),chr(10),'') as start_date
,replace(replace(t1.mtr_date,chr(13),''),chr(10),'') as mtr_date
,replace(replace(t1.interest_acc_mode,chr(13),''),chr(10),'') as interest_acc_mode
,replace(replace(t1.early_end_date,chr(13),''),chr(10),'') as early_end_date
,replace(replace(t1.is_agree_amount_fixed,chr(13),''),chr(10),'') as is_agree_amount_fixed
,agree_amount
,agree_amount_rate
,agree_current_rate
,agree_break_contract_rate
,replace(replace(t1.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.is_delete,chr(13),''),chr(10),'') as is_delete
,replace(replace(t1.first_payment_date,chr(13),''),chr(10),'') as first_payment_date
,replace(replace(t1.break_info_flag,chr(13),''),chr(10),'') as break_info_flag
,replace(replace(t1.gear_prod_flag,chr(13),''),chr(10),'') as gear_prod_flag
,replace(replace(t1.agree_freq,chr(13),''),chr(10),'') as agree_freq
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.is_monthly_mode,chr(13),''),chr(10),'') as is_monthly_mode
,stride_month_rate
,not_stride_month_rate
,replace(replace(t1.stride_month_remark,chr(13),''),chr(10),'') as stride_month_remark
,replace(replace(t1.not_stride_month_remark,chr(13),''),chr(10),'') as not_stride_month_remark
,replace(replace(t1.near_rate_json,chr(13),''),chr(10),'') as near_rate_json
,replace(replace(t1.multy_mode,chr(13),''),chr(10),'') as multy_mode
,replace(replace(t1.core_status,chr(13),''),chr(10),'') as core_status

from ${iol_schema}.ibms_ttrd_cross_border_rmb t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_cross_border_rmb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
