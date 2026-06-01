: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_capital_repay_plan_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_capital_repay_plan_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(amount,chr(10),''),chr(13),'') as amount
,replace(replace(repay_date,chr(10),''),chr(13),'') as repay_date
,replace(replace(repay_type,chr(10),''),chr(13),'') as repay_type
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_capital_repay_plan
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_capital_repay_plan_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes