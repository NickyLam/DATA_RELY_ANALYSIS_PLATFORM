: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_difrepayment_plan_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_difrepayment_plan_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.duebillserialno,chr(13),''),chr(10),'') as duebillserialno
    ,replace(replace(t.startdate,chr(13),''),chr(10),'') as startdate
    ,replace(replace(t.executiondate,chr(13),''),chr(10),'') as executiondate
    ,replace(replace(t.businesscurrency,chr(13),''),chr(10),'') as businesscurrency
    ,t.normalsum as normalsum
    ,t.periodsum as periodsum
    ,t.periodinterestsum as periodinterestsum
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_difrepayment_plan_info t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_difrepayment_plan_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes