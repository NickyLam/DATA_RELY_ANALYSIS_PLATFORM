: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_acct_protocol_master_f
CreateDate: 20240903
FileName:   ${iel_data_path}/ibms_ttrd_acct_protocol_master.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.accid,chr(13),''),chr(10),'') as accid
,replace(replace(t1.settle_period,chr(13),''),chr(10),'') as settle_period
,replace(replace(t1.start_date,chr(13),''),chr(10),'') as start_date
,replace(replace(t1.expire_date,chr(13),''),chr(10),'') as expire_date
,replace(replace(t1.early_end_date,chr(13),''),chr(10),'') as early_end_date
,amount
,amount_rate
,break_rate
,current_rate
,replace(replace(t1.contract_no,chr(13),''),chr(10),'') as contract_no
,usable_flag
,replace(replace(t1.operate,chr(13),''),chr(10),'') as operate
,replace(replace(t1.ctrct_id,chr(13),''),chr(10),'') as ctrct_id
,replace(replace(t1.first_payment_date,chr(13),''),chr(10),'') as first_payment_date
,replace(replace(t1.is_monthly_mode,chr(13),''),chr(10),'') as is_monthly_mode
,replace(replace(t1.is_near_rate_mode,chr(13),''),chr(10),'') as is_near_rate_mode
,stride_month_rate
,not_stride_month_rate
,replace(replace(t1.stride_month_remark,chr(13),''),chr(10),'') as stride_month_remark
,replace(replace(t1.not_stride_month_remark,chr(13),''),chr(10),'') as not_stride_month_remark
,replace(replace(t1.fix_settle_period,chr(13),''),chr(10),'') as fix_settle_period
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iol_schema}.ibms_ttrd_acct_protocol_master t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_acct_protocol_master.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
