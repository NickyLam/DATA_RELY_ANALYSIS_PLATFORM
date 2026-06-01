: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_capital_repay_plan_f
CreateDate: 20221021
FileName:   ${iel_data_path}/ibms_ttrd_capital_repay_plan.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(i_code,chr(13),''),chr(10),'')
,replace(replace(a_type,chr(13),''),chr(10),'')
,replace(replace(m_type,chr(13),''),chr(10),'')
,amount
,replace(replace(repay_date,chr(13),''),chr(10),'')
,replace(replace(repay_type,chr(13),''),chr(10),'')
,replace(replace(remark,chr(13),''),chr(10),'')
,ai

from ${iol_schema}.ibms_ttrd_capital_repay_plan t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_capital_repay_plan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
